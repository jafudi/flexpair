#!/bin/sh -eux

echo "Running script networking.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
apt-get -qq install --no-install-recommends \
net-tools \
darkstat

cat <<EOF > /etc/darkstat/init.cfg
START_DARKSTAT=yes

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i ens3"

DIR="/var/lib/darkstat"
PORT="-p 667"
EOF
systemctl enable darkstat.service
systemctl start darkstat.service

