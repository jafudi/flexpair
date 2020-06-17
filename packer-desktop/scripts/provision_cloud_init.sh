#!/usr/bin/env bash

REQUIRED_PKG="cloud-init"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "Install cloud-init..."
    # Prepare for cloud-init to run at next boot
    DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --upgrade -y --no-install-recommends cloud-init
    cp /var/tmp/traction/cloud-init/cloud.cfg /etc/cloud/cloud.cfg

    echo "datasource_list: [ NoCloud, None ]" | sudo tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg

    # Prepare for Oracle Cloud Infrastructure
    cp /var/tmp/traction/cloud-init/grub.cfg /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Clean reboot..."
cloud-init clean --logs

echo "Please create a DNS A record from your sub domain to the public IP address of the VM."
echo "Then press any key to continue..."
read -r reply

reboot
