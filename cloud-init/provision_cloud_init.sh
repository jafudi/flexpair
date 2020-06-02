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
else
    echo "Wait for cloud-init to finish..."
    set +e
    cloud-init status --long --wait
    set -e
    cloud-init collect-logs
    tar -xzf cloud-init.tar.gz
    rm -f cloud-init.tar.gz
    cd cloud-init-logs*
    cat /var/log/cloud-init-output.log
    cd ..
fi

