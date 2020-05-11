#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --upgrade -y --no-install-recommends x11vnc net-tools
mkdir -p /home/vagrant/.vnc
x11vnc -storepasswd "vagrant" /home/vagrant/.vnc/passwd



