#!/bin/sh -eux

sudo sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;

# Set up password-less sudo for the ubuntu user
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/99_user;
sudo chmod 440 /etc/sudoers.d/99_user;
