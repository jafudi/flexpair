#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade sshfs

mkdir -p $HOME/Desktop/Uploads
chown ubuntu -R $HOME/Desktop/Uploads

cat << EOF >> /etc/fstab
ubuntu@${SSL_SUB_DOMAIN}:/home/ubuntu /home/ubuntu/Desktop/Uploads \
fuse.sshfs noauto,x-systemd.automount,_netdev,users,idmap=user,IdentityFile=/var/tmp/ssh/vm_key,allow_other,reconnect 0 0
EOF



