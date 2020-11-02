#!/bin/sh -eux

echo "Running script sudoers.sh..."
echo

# Set up password-less sudo for the ubuntu user
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99_user;
chmod 440 /etc/sudoers.d/99_user;

chown -R ubuntu /home/ubuntu