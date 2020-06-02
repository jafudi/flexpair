#!/bin/bash -eux

apt-get clean
apt-get update --fix-missing

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
--upgrade lubuntu-desktop virtualbox-guest-x11 elementary-icon-theme locales less kdialog

apt-get autoremove -y \
--purge xscreensaver bluedevil

cat << EOF > /etc/sddm.conf
[Autologin]
# Whether sddm should automatically log back into sessions when they exit
Relogin=false

# Name of session file for autologin session (if empty try last logged in)
Session=Lubuntu.desktop

# Username for autologin session
User=ubuntu
EOF

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

