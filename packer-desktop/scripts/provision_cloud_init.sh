#!/usr/bin/env bash

# https://cloudinit.readthedocs.io/en/latest/
# https://help.ubuntu.com/community/CloudInit

REQUIRED_PKG="cloud-init"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "Install cloud-init..."
    # Prepare for cloud-init to run at next boot
    DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --upgrade -y --no-install-recommends cloud-init
fi

echo "Clean reboot..."
cloud-init clean --logs


