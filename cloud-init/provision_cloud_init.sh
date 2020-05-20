#!/usr/bin/env bash

# Prepare for cloud-init to run at next boot
DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --upgrade -y --no-install-recommends cloud-init
cp /var/tmp/traction/cloud-init/cloud.cfg /etc/cloud/cloud.cfg

# How to merge with Oracle datasource?
echo "datasource_list: [ NoCloud, None ]" | sudo tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg

# Prepare for Oracle Cloud Infrastructure
cp /var/tmp/traction/cloud-init/grub.cfg /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
