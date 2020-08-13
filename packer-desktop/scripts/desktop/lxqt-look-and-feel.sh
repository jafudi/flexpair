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

cd /etc/xdg/autostart/
rm -f lxqt-globalkeyshortcuts.desktop
rm -f lxqt-powermanagement.desktop
rm -f lxqt-xscreensaver-autostart.desktop
rm -f nm-applet.desktop
rm -f nm-tray-autostart.desktop
rm -f snap-userd-autostart.desktop
rm -f upg-notifier-autostart.desktop

FILES="lxqt-hibernate
lxqt-leave
lxqt-lockscreen
lxqt-logout
lxqt-reboot
lxqt-shutdown
lxqt-suspend"

LOCAL_DIR=/home/ubuntu/.local
mkdir -p "${LOCAL_DIR}/share/applications"
for f in $FILES
do
 echo "Processing $f"
 sed '/OnlyShowIn/aNoDisplay=true' < "/usr/share/applications/$f.desktop" >\
  "${LOCAL_DIR}/share/applications/$f.desktop"
done

