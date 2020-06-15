#!/usr/bin/env bash

FILES="lxqt-hibernate
lxqt-leave
lxqt-lockscreen
lxqt-logout
lxqt-reboot
lxqt-shutdown
lxqt-suspend"

mkdir -p /home/ubuntu/.local/share/applications
for f in $FILES
do
 echo "Processing $f"
 sed '/OnlyShowIn/aNoDisplay=true' < "/usr/share/applications/$f.desktop" >\
  "/home/ubuntu/.local/share/applications/$f.desktop"
done