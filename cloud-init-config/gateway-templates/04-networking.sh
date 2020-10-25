#!/bin/sh -eux

echo "Running script networking.sh..."

echo "Create netplan config for eth0"
cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml;
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF

# Disable Predictable Network Interface names and use eth0
sudo sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 \1"/g' /etc/default/grub;
sudo update-grub;

# Allow connections to non-standard localhost ports which are necessary for the 'nginx' and 'guac' containers
# which do have their own IP addresses within a virtualized Docker network while still running on the same VM
sudo iptables -I INPUT 1 -p tcp --dport 5900 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac container to VNC
sudo iptables -I INPUT 2 -p tcp --dport 4713 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac container to PulseAudio
sudo iptables -I INPUT 3 -p tcp --dport 2222 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac via SSH to desktop
sudo iptables -I INPUT 4 -p tcp --dport 667 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # nginx to DarkStat on gateway
sudo iptables -I INPUT 5 -p tcp --dport 6667 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # nginx to DarkStat on desktop
sudo netfilter-persistent save

cat <<EOF | sudo tee /etc/darkstat/init.cfg
START_DARKSTAT=yes

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i eth0"

DIR="/var/lib/darkstat"
PORT="-p 667"
EOF
sudo systemctl enable darkstat.service
sudo systemctl start darkstat.service

