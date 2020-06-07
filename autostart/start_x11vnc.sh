#!/usr/bin/env bash

startx &
sudo /usr/bin/x11vnc -create -auth guess -forever -loop -noxdamage -o /var/log/x11vnc.log -rfbauth jafudi -rfbport 5900 -shared
