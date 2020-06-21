#!/usr/bin/env bash

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
chown ubuntu -R ${LOCAL_DIR}