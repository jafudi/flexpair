#!/usr/bin/env bash

cat << 'EOF' >> /etc/sysctl.conf
vm.swappiness = 1
EOF

apt install make fakeroot

git clone https://github.com/hakavlad/nohang.git && cd nohang
deb/build.sh

apt install --reinstall ./deb/package.deb

systemctl enable nohang-desktop
systemctl start nohang-desktop