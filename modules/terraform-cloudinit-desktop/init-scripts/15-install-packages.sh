#!/bin/bash -eux

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update > /dev/null

apt-get -qq install software-properties-common
apt-get -qq update > /dev/null

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
gnome-clocks

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


wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | dd of=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg

echo 'deb [signed-by=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' \
    | tee /etc/apt/sources.list.d/vscodium.list

apt update
apt install codium


rm -rf /var/log/unattended-upgrades
apt-get -qq purge unattended-upgrades snapd apport
apt-get -qq autoremove
