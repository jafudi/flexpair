#!/bin/sh -eux

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
mtr net-tools \
darkstat

echo "Create netplan config for eth0"
cat <<EOF >/etc/netplan/01-netcfg.yaml;
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF

# Disable Predictable Network Interface names and use eth0
sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 \1"/g' /etc/default/grub;
update-grub;

# The following three lines circumvent a hardly documented reject rule on Oracle Cloud provided images
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends iptables-persistent
iptables -I INPUT 1 -p tcp --dport 5900 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # VNC incoming
iptables -I INPUT 2 -p tcp --dport 4713 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # PulseAudio incoming
iptables -I INPUT 3 -p tcp --dport 64738 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # Mumble incoming
iptables -I INPUT 4 -p udp --dport 64738 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # Mumble incoming
netfilter-persistent save

cat <<EOF >/etc/darkstat/init.cfg
START_DARKSTAT=yes

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE="-i eth0"

DIR="/var/lib/darkstat"
PORT="-p 5080"
BINDIP="-b 127.0.0.1"
#LOCAL="-l 192.168.0.0/255.255.255.0"

# File will be relative to $DIR:
#DAYLOG="--daylog darkstat.log"

# Don't reverse resolve IPs to host names
#DNS="--no-dns"

#FILTER="not (src net 192.168.0 and dst net 192.168.0)"

# Additional command line Arguments:
# OPTIONS="--syslog --no-macs"
EOF
service darkstat enable
service darkstat start

