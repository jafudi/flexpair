#!/bin/sh -eux

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

# Set up password-less sudo
echo "${DESKTOP_USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_user;
chmod 440 /etc/sudoers.d/99_user;

chown -R "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}"