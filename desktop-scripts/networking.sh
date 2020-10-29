#!/bin/sh -eux

echo "Running script networking.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install --no-install-recommends \
mtr net-tools \
darkstat

cat <<EOF | sudo tee /etc/darkstat/init.cfg
START_DARKSTAT=yes

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i ens3"

DIR="/var/lib/darkstat"
PORT="-p 667"
EOF
sudo systemctl enable darkstat.service
sudo systemctl start darkstat.service

