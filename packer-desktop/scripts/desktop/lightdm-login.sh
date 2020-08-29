#!/usr/bin/env bash

apt-get install -y --no-install-recommends --upgrade \
lightdm \
lightdm-gtk-greeter \
lightdm-gtk-greeter-settings \
accountsservice \
policykit-1 policykit-desktop-privileges

mkdir -p /etc/lightdm
cat << EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
EOF
systemctl enable lightdm.service
usermod -aG nopasswdlogin ubuntu
