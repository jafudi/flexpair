#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update > /dev/null

apt-get -qq install software-properties-common
apt-get -qq update > /dev/null

add-apt-repository 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main'
add-apt-repository universe
apt-get -qq update > /dev/null

apt-get -qq install \
less nano \
glances \
build-essential \
sshfs \
nodejs npm \
vym \
frozen-bubble blockout2 biniax2 kdegames \
simplescreenrecorder \
qtqr \
falkon \
variety \
gnome-clocks \
qtcreator \
codium

apt-get -qq install tuxmath tuxpaint
# https://wiki.ubuntuusers.de/Tux_Paint/
mkdir -p /etc/tuxpaint/
cat << EOF > /etc/tuxpaint/tuxpaint.conf
fullscreen=native
noshortcuts=yes
alllocalefonts=yes
noprint=yes
savedir=/home/ubuntu/Desktop/Uploads/
EOF
chown -R ubuntu /etc/tuxpaint/


rm -rf /var/log/unattended-upgrades
apt-get -qq purge unattended-upgrades snapd apport
apt-get -qq autoremove
