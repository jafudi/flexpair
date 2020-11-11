#!/bin/sh -eux

mkdir -p /etc/darkstat
cat <<EOF > /etc/darkstat/init.cfg
START_DARKSTAT=yes
# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i ens3"
DIR="/var/lib/darkstat"
PORT="-p 667"
EOF
systemctl start darkstat
/lib/systemd/systemd-sysv-install enable darkstat