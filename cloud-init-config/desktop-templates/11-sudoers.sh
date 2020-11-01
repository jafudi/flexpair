#!/bin/sh -eux

echo "Running script sudoers.sh..."
echo

# Set up password-less sudo for the ubuntu user
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/99_user;
sudo chmod 440 /etc/sudoers.d/99_user;

sudo chown -R ubuntu /home/ubuntu