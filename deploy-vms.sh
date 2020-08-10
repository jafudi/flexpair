#!/usr/bin/env bash

clear && printf '\e[3J'
PACKFOLDER=$PWD/packer-desktop
cat ${PACKFOLDER}/vartmp-uploads/gateway/ascii-art

FROM_SCRATCH=true
EXCLUDE=""
DYNU_API_KEY="56ge3636efbe35323352VX6d6c4dY4f5"

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

function check_size() {
    size_bytes=$(stat -f "%z" $1)
    MAX_USERDATA_BYTES=32000
    if [[ "${size_bytes}" -gt "${MAX_USERDATA_BYTES}" ]]; then
        echo "Metadata size is ${size_bytes} bytes and cannot be larger than ${MAX_USERDATA_BYTES} bytes."
        exit 1
    fi
}

export SSL_DOMAIN=${SUB_DOMAIN_PREFIX}.${REGISTERED_DOMAIN}
EXPAND_FOLDER="${PACKFOLDER}/builds"
envsubst '${SSL_DOMAIN}' < cloud-init/gateway-userdata.tpl > "${EXPAND_FOLDER}/gateway-userdata"
check_size "${EXPAND_FOLDER}/gateway-userdata"
envsubst '${SSL_DOMAIN}' < cloud-init/desktop-userdata.tpl > packer-desktop/builds/desktop-userdata
check_size "${EXPAND_FOLDER}/desktop-userdata"

MURMUR_CONF="packer-desktop/vartmp-uploads/gateway/guacamole/murmur_config"
envsubst '${SUB_DOMAIN_PREFIX}.${REGISTERED_DOMAIN}' < "${MURMUR_CONF}/murmur.tpl" > "${MURMUR_CONF}/murmur.ini"

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
        echo "Creating dynamic DNS record $EXCLUDE for domain ${SSL_DOMAIN}..."
        DYNU_API_URL="https://api.dynu.com/v2"
        curl -X POST "${DYNU_API_URL}/dns" \
             -H "accept: application/json" \
             -H "API-Key: ${DYNU_API_KEY}" \
             -H "Content-Type: application/json" \
             -d "{\"name\":\"${SSL_DOMAIN}\",\"ipv4Address\":\"1.2.3.4\",\"ttl\":120,\"ipv4\":true,\"ipv6\":false,\"ipv4WildcardAlias\":true,\"ipv6WildcardAlias\":false,\"allowZoneTransfer\":false,\"dnssec\":false}"
        DYNU_STATUS=$(curl --silent -X GET "${DYNU_API_URL}/dns" \
             -H "accept: application/json" \
             -H "API-Key: ${DYNU_API_KEY}")
        ;;
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