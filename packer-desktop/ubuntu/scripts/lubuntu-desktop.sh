#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive" apt-get autoremove -y --purge ubuntu-desktop kubuntu-desktop xubuntu-desktop
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends lubuntu-desktop gdm3-
DEBIAN_FRONTEND="noninteractive" apt-get autoremove -y --purge xscreensaver bluedevil

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
