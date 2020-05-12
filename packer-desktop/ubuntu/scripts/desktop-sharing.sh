#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive"

apt-get install -y --no-install-recommends \
--upgrade x11vnc net-tools

mkdir -p /home/vagrant/.vnc
x11vnc -storepasswd "vagrant" /home/vagrant/.vnc/passwd