#!/usr/bin/env bash

# http://www.oracle.com/us/technologies/virtualization/oracle-vm-vb-oci-export-20190502-5480003.pdf

echo 'GRUB_TERMINAL="console serial"' | sudo tee -a /etc/default/grub
echo 'GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 console=tty0 console=ttyS0,115200 ds=nocloud-net"' | sudo tee -a /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

rm -rf /var/lib/cloud/*

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends cloud-init

YAML="/var/lib/cloud/seed/nocloud-net"
mkdir -p ${YAML}
cp ./host/cloud-init/seed/nocloud-net/meta-data.yaml "$YAML/meta-data"
cp ./host/cloud-init/seed/nocloud-net/user-data.yaml "$YAML/user-data"

SCRIPTS="/var/lib/cloud/scripts"
mkdir -p "$SCRIPTS/per-instance/"
mkdir -p "$SCRIPTS/per-boot/"
cp ./host/cloud-init/scripts/per-instance/*.sh "$SCRIPTS/per-instance/"
cp ./host/cloud-init/scripts/per-boot/*.sh "$SCRIPTS/per-boot/"
find ${SCRIPTS} -type f -iname "*.sh" -exec chmod +x {} \;