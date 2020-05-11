#!/usr/bin/env bash

# http://www.oracle.com/us/technologies/virtualization/oracle-vm-vb-oci-export-20190502-5480003.pdf

echo 'GRUB_TERMINAL="console serial"' | sudo tee -a /etc/default/grub
echo 'GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 console=tty0 console=ttyS0,115200 ds=nocloud-net"' | sudo tee -a /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

rm -rf /var/lib/cloud/*

DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --upgrade -y --no-install-recommends cloud-init

cp -fRv /var/tmp/traction/cloud-init/ /var/lib/cloud/
find /var/lib/cloud/scripts -type f -iname "*.sh" -exec chmod +x {} \;
