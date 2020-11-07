#!/bin/sh -eux

echo "Running script sudoers.sh..."
echo

# Set up password-less sudo
echo "${DESKTOP_USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_user;
chmod 440 /etc/sudoers.d/99_user;

chown -R "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}"