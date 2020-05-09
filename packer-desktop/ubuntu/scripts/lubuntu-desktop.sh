#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive"

apt-get autoremove -y \
--purge ubuntu-desktop kubuntu-desktop xubuntu-desktop

apt-get install -y --no-install-recommends \
--upgrade lubuntu-desktop virtualbox-guest-x11 kdialog elementary-icon-theme gdm3-

apt-get autoremove -y \
--purge xscreensaver bluedevil

cat << EOF > /etc/sddm.conf
[Autologin]
# Whether sddm should automatically log back into sessions when they exit
Relogin=false

# Name of session file for autologin session (if empty try last logged in)
Session=Lubuntu.desktop

# Username for autologin session
User=vagrant
EOF

reboot
