#!/bin/sh -eux

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

export DEBIAN_FRONTEND="noninteractive"
apt-get -qq install --no-install-recommends \
darkstat \
net-tools \
glances

cat <<EOF | sudo tee /etc/darkstat/init.cfg
START_DARKSTAT=yes
# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i ens3"
DIR="/var/lib/darkstat"
PORT="-p 667"
EOF
systemctl start darkstat
/lib/systemd/systemd-sysv-install enable darkstat