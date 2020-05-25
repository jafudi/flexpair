#!/usr/bin/env bash

mkdir -p /home/ubuntu/.config/autostart

cp /var/tmp/traction/autostart/* /home/ubuntu/.config/autostart/

find /home/ubuntu/.config/autostart -type f -exec chmod +x {} \;