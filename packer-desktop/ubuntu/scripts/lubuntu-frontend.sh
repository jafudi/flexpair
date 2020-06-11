#!/bin/bash -eux

apt-get clean
apt-get update --fix-missing

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
--upgrade lubuntu-desktop lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings accountsservice policykit-1 virtualbox-guest-x11 elementary-icon-theme locales nano less kdialog

cat << EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
autologin-user=ubuntu
autologin-user-timeout=5
EOF
systemctl enable lightdm.service
usermod -aG nopasswdlogin ubuntu



apt-get autoremove -y \
--purge xscreensaver bluedevil

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
qpdfview \
lximage-qt \
screengrab \
ark \
featherpad \
kcalc \
qlipper \
gnumeric gnumeric-plugins-extra gnumeric-doc \
trojita \
cutemaze \
firefox

cat << EOF > /usr/lib/firefox/browser/defaults/preferences/sysprefs.js
pref("browser.startup.homepage","jafudi.com");
EOF

