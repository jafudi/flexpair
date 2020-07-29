#!/bin/sh -eux

passwd -d ubuntu

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;

# Set up password-less sudo for the ubuntu user
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/99_user;
chmod 440 /etc/sudoers.d/99_user;

HOME_DIR="/home/ubuntu"
chown -R ubuntu $HOME_DIR
chmod -R go-rwsx $HOME_DIR