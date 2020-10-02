#!/bin/sh -eux

echo "Running script networking.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get install -y --no-install-recommends --upgrade \
mtr net-tools \
darkstat

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

# The following three lines circumvent a hardly documented reject rule on Oracle Cloud provided images
sudo -E apt-get install -y --no-install-recommends iptables-persistent
sudo iptables -I INPUT 1 -p tcp --dport 5900 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # VNC incoming
sudo iptables -I INPUT 2 -p tcp --dport 4713 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # PulseAudio incoming
sudo iptables -I INPUT 3 -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # SMTP
sudo iptables -I INPUT 4 -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # IMAP
sudo iptables -I INPUT 5 -p tcp --dport 5060 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # SIP
sudo iptables -I INPUT 6 -p tcp --dport 7078 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # RTP
sudo iptables -I INPUT 7 -p tcp --dport 667 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # DarkStat for gateway
sudo iptables -I INPUT 8 -p tcp --dport 6667 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # DarkStat for desktop
sudo netfilter-persistent save

cat <<EOF | sudo tee /etc/darkstat/init.cfg
START_DARKSTAT=yes

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i eth0"

DIR="/var/lib/darkstat"
PORT="-p 667"
#BINDIP="-b 127.0.0.1"
#LOCAL="-l 192.168.0.0/255.255.255.0"

#DAYLOG="--daylog darkstat.log"

# Don't reverse resolve IPs to host names
#DNS="--no-dns"

#FILTER="not (src net 192.168.0 and dst net 192.168.0)"

# Additional command line Arguments:
# OPTIONS="--syslog --no-macs"
EOF
sudo systemctl enable darkstat.service
sudo systemctl start darkstat.service

