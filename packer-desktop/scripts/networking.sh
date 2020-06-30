#!/bin/sh -eux

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
iptables -I INPUT 1 -p tcp --dport 5900 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # VNC
iptables -I INPUT 2 -p tcp --dport 64738 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # Mumble
iptables -I INPUT 3 -p udp --dport 64738 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # Mumble
netfilter-persistent save

