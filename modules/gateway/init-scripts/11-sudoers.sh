#!/bin/sh -eux

echo "Running script sudoers.sh..."
echo

# Set up password-less sudo
echo "${GATEWAY_USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_user;
chmod 440 /etc/sudoers.d/99_user;

chown -R "${GATEWAY_USERNAME}" "/home/${GATEWAY_USERNAME}"