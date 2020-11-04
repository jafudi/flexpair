#!/bin/sh -eux

echo "Running script networking.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install --no-install-recommends \
net-tools glances \
darkstat iptables-persistent

# Allow connections to non-standard localhost ports which are necessary for the 'nginx' and 'guac' containers
# which do have their own IP addresses within a virtualized Docker network while still running on the same VM
iptables -I INPUT 1 -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac container to VNC
netfilter-persistent save

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
