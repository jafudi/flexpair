#!/usr/bin/env bash

cat << 'EOF' >> /etc/sysctl.conf
vm.swappiness = 1
EOF

git clone https://github.com/hakavlad/nohang.git && cd nohang
make install

# Config files will be located in /usr/local/etc/nohang/

systemctl enable nohang-desktop
systemctl start nohang-desktop