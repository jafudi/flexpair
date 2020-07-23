#!/usr/bin/env bash

SSH_KEY_FOLDER="/Users/jens/PycharmProjects/traction/packer-desktop/uploads/ssh"
mkdir -p ${SSH_KEY_FOLDER}
PRIVKEY_FILE="${SSH_KEY_FOLDER}/vm_key"
ssh-keygen -b 2048 -t rsa -f ${PRIVKEY_FILE} -q -N "" # <<< y
PUBKEY_FILE="${PRIVKEY_FILE}.pub"

packer build \
        -only=lubuntu-desktop,guacamole-gateway \
        -var "ssl_sub_domain=tryno2.theworkpc.com" \
        -var "ssh_public_key=$(cat ${PUBKEY_FILE})" \
        -var "private_key_file=$PRIVKEY_FILE" \
        -var "ssh_keypair_name=$USER@$HOSTNAME" \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json