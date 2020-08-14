#!/usr/bin/env bash

source "./assert_helpers.sh"
source "./dns_helpers.sh"

clear && printf '\e[3J'
PACKFOLDER=$PWD/packer-desktop
cat ${PACKFOLDER}/vartmp-uploads/gateway/ascii-art

FROM_SCRATCH=true
EXCLUDE=""
export REGISTERED_DOMAIN=$(random_free_registered_domain)

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -key=*|--api-key=*)
        DYNU_API_KEY="${arg#*=}"
        shift # Remove --api-key= from processing
        ;;
        -desktop|--desktop-only)
        EXCLUDE="-except=guacamole-gateway"
        FROM_SCRATCH=false
        shift # Remove --desktop-only from processing
        ;;
        -domain=*|--registered-domain=*)
        export REGISTERED_DOMAIN="${arg#*=}"
        shift # Remove --registered-domain= from processing
        ;;
        -subdomain=*|--subdomain-prefix=*)
        export SUB_DOMAIN_PREFIX="${arg#*=}"
        shift # Remove --subdomain-prefix= from processing
        ;;
        -target=*|--cloud-target=*)
        TARGET="${arg#*=}"
        shift # Remove --cloud-target= from processing
        ;;
        *)
        OTHER_ARGUMENTS+=("$1")
        shift # Remove generic argument from processing
        ;;
    esac
done

export SSL_DOMAIN=${SUB_DOMAIN_PREFIX}.${REGISTERED_DOMAIN}
export EMAIL_ADDRESS="socialnets@jafudi.com"
export IMAP_HOST="s44.internetwerk.de"
export IMAP_PASSWORD="JeedsEyruwiwez^"
export MURMUR_PORT="64738"
EXPAND_FOLDER="${PACKFOLDER}/builds"
envsubst '${SSL_DOMAIN},${EMAIL_ADDRESS},${MURMUR_PORT}' < cloud-init/gateway-userdata.tpl > "${EXPAND_FOLDER}/gateway-userdata"
check_size "${EXPAND_FOLDER}/gateway-userdata"
envsubst '${SSL_DOMAIN},${SUB_DOMAIN_PREFIX},${EMAIL_ADDRESS},${IMAP_HOST},${IMAP_PASSWORD},${MURMUR_PORT}' < cloud-init/desktop-userdata.tpl > packer-desktop/builds/desktop-userdata
check_size "${EXPAND_FOLDER}/desktop-userdata"

MURMUR_CONF="packer-desktop/vartmp-uploads/gateway/guacamole/murmur_config"
envsubst '${SUB_DOMAIN_PREFIX},${REGISTERED_DOMAIN},${MURMUR_PORT}' < "${MURMUR_CONF}/murmur.tpl.ini" > "${MURMUR_CONF}/murmur.ini"

DOCKER_COMPOSE="packer-desktop/vartmp-uploads/gateway/guacamole"
envsubst '${MURMUR_PORT}' < "${DOCKER_COMPOSE}/docker-compose.tpl.yml" > "${DOCKER_COMPOSE}/docker-compose.yml"

TARGET="${PACKFOLDER}/oracle-cloud-free-setup.json"
packer validate ${TARGET}  || exit 1

ping -c 1 -W 2 ${SSL_DOMAIN}  ;  PING_STATUS=`echo $?`
case ${PING_STATUS} in
    0)
    echo "There is already a host responding under this IP address."
    ;;
    2)
    echo "This domain is pointing into the void."
    ;;
    *)
    echo "No DNS records seem to exist for this (sub)domain."
    ;;
esac

SSH_KEY_FOLDER="${PACKFOLDER}/vartmp-uploads/common/ssh"
PRIVKEY_FILE="${SSH_KEY_FOLDER}/vm_key"
PUBKEY_FILE="${PRIVKEY_FILE}.pub"
COMMENT="$USER@$HOSTNAME"

if ${FROM_SCRATCH} ; then
    case ${PING_STATUS} in
        0)
        echo "You may have to either remove the cloud VM first"
        sleep 5
        echo "OR accept that the domain will point to a new IP."
        sleep 5
        ;;
        2)
        echo "The VM was probably already terminated."
        ;;
        *)
        create_ddns_record ${SSL_DOMAIN}
    esac
    mkdir -p ${SSH_KEY_FOLDER}
    echo
    echo "Generate a new SSH key..."
    ssh-keygen -t ed25519 -f ${PRIVKEY_FILE} -q -N "" -C ${COMMENT} || exit 1
else
    case ${PING_STATUS} in
        0)
        echo "This is probably your running gateway."
        ;;
        2)
        echo "Please deploy from scratch."
        exit 1
        ;;
        *)
        echo "Please deploy from scratch."
        exit 1
        ;;
    esac
fi

wait_for_dns_propagation ${SSL_DOMAIN}

echo "Provisioning VM(s) $EXCLUDE"
echo "This will take some minutes..."

packer build \
-timestamp-ui \
${EXCLUDE} \
-var "ssh_public_key=$(cat ${PUBKEY_FILE})" \
-var "private_key_file=${PRIVKEY_FILE}" \
-var "ssh_keypair_name=${COMMENT}" \
-on-error=abort \
${TARGET}

open -a "Google Chrome" "https://${SSL_DOMAIN}"