#!/usr/bin/env bash

mkdir -p /home/vagrant/.config/autostart

cp /var/tmp/traction/autostart/* /home/vagrant/.config/autostart/

find /home/vagrant/.config/autostart -type f -exec chmod +x {} \;