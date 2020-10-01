#!/usr/bin/env bash

source "./assert_helpers.sh"

function check_size() {
    size_bytes=$(stat -f "%z" $1)
    MAX_USERDATA_BYTES=32000
    assert_le "${size_bytes}" "${MAX_USERDATA_BYTES}" "Metadata too large." || exit 1
}

domain_vars='${SSL_DOMAIN},${SUB_DOMAIN_PREFIX},${REGISTERED_DOMAIN}'
email_vars='${EMAIL_ADDRESS},${IMAP_HOST},${IMAP_PASSWORD}'
murmur_vars='${MURMUR_PORT},${MURMUR_PASSWORD}'

envsubst ${domain_vars},${email_vars},${murmur_vars} < cloud-init/gateway-userdata.tpl > "${EXPAND_FOLDER}/gateway-userdata"
check_size "${EXPAND_FOLDER}/gateway-userdata"
envsubst ${domain_vars},${email_vars},${murmur_vars} < cloud-init/desktop-userdata.tpl > packer-desktop/builds/desktop-userdata
check_size "${EXPAND_FOLDER}/desktop-userdata"

MURMUR_CONF="packer-desktop/vartmp-uploads/gateway/guacamole/murmur_config"
envsubst ${domain_vars},${murmur_vars} < "${MURMUR_CONF}/murmur.tpl.ini" > "${MURMUR_CONF}/murmur.ini"

DOCKER_COMPOSE="packer-desktop/vartmp-uploads/gateway/guacamole"
envsubst ${domain_vars},${email_vars},${murmur_vars} < "${DOCKER_COMPOSE}/docker-compose.tpl.yml" > "${DOCKER_COMPOSE}/docker-compose.yml"

TARGET="${PACKFOLDER}/oracle-cloud-free-setup.json"
packer validate ${TARGET}  || exit 1

SSH_KEY_FOLDER="${PACKFOLDER}/vartmp-uploads/common/ssh"
PRIVKEY_FILE="${SSH_KEY_FOLDER}/vm_key"
PUBKEY_FILE="${PRIVKEY_FILE}.pub"
COMMENT="$USER@$HOSTNAME"

echo "This will take some minutes..."

packer build \
-var "ssh_public_key=$(cat ${PUBKEY_FILE})" \
-var "private_key_file=${PRIVKEY_FILE}" \
-var "ssh_keypair_name=${COMMENT}" \
-var "full_domain=${SSL_DOMAIN}" \
-on-error=abort \
${TARGET}

open -a "Google Chrome" "https://${SSL_DOMAIN}"