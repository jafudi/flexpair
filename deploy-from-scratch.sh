#!/usr/bin/env bash

SSH_KEY_FOLDER="/Users/jens/PycharmProjects/traction/packer-desktop/uploads/ssh"
mkdir -p ${SSH_KEY_FOLDER}
PRIVKEY_FILE="${SSH_KEY_FOLDER}/vm_key
PASSPHRASE=""
COMMENT="$USER@$HOSTNAME"
ssh-keygen -t ed25519 -f ${PRIVKEY_FILE} -q -N ${PASSPHRASE} -C ${COMMENT}# <<< y
PUBKEY_FILE="${PRIVKEY_FILE}.pub"

packer build \
-var "ssl_sub_domain=tryno3.theworkpc.com" \
-var "ssh_public_key=$(cat ${PUBKEY_FILE})" \
-var "private_key_file=$PRIVKEY_FILE" \
-var "ssh_keypair_name=${COMMENT}" \
-on-error=abort \
packer-desktop/oracle-cloud-free-setup.json