#!/usr/bin/env bash

SSH_KEY_FOLDER="/Users/jens/PycharmProjects/traction/packer-desktop/uploads/ssh"
PRIVKEY_FILE="${SSH_KEY_FOLDER}/vm_key"
PUBKEY_FILE="${PRIVKEY_FILE}.pub"

packer build \
-only=lubuntu-desktop \
-var "ssl_sub_domain=tryno4.theworkpc.com" \
-var "ssh_public_key=$(cat ${PUBKEY_FILE})" \
-var "private_key_file=$PRIVKEY_FILE" \
-var "ssh_keypair_name=$USER@$HOSTNAME" \
-on-error=abort \
packer-desktop/oracle-cloud-free-setup.json