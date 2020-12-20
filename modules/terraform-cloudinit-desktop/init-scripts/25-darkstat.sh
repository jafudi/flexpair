#!/bin/bash -eux

apt-get -qq install \
darkstat \
net-tools

mkdir -p /etc/darkstat
cat <<EOF > /etc/darkstat/init.cfg
START_DARKSTAT=yes
# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i ${PRIMARY_NIC}"
DIR="/var/lib/darkstat"
PORT="-p 667"
EOF


systemctl start darkstat
/lib/systemd/systemd-sysv-install enable darkstat
