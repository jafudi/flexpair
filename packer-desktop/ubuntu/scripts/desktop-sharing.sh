#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive"

apt-get install -y --no-install-recommends \
--upgrade x11vnc xvfb xterm net-tools

mkdir -p /home/ubuntu/.vnc
x11vnc -storepasswd "ubuntu" /home/ubuntu/.vnc/passwd

mkdir -p /home/ubuntu/.config/autostart

cd /var/tmp
rm -rf traction
git clone --depth 1 https://github.com/jafudi/traction.git --branch master
sudo chmod 777 -R traction
cp /var/tmp/traction/autostart/* /home/ubuntu/.config/autostart/

find /home/ubuntu/.config/autostart -type f -exec chmod +x {} \;
