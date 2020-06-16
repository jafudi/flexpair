#!/usr/bin/env bash

CONFIG_DIR=/home/ubuntu/.config
mkdir -p "${CONFIG_DIR}/lxqt"
cat << EOF > "${CONFIG_DIR}/lxqt/lxqt.conf"
[General]
__userfile__=true
icon_follow_color_scheme=true
icon_theme=ePapirus
single_click_activate=true
theme=Lubuntu Arc

[Qt]
style=Breeze
EOF
chown ubuntu -R ${CONFIG_DIR}
