#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive"

apt-get install -y --no-install-recommends \
--upgrade x11vnc xterm net-tools

mkdir -p /home/ubuntu/.vnc
x11vnc -storepasswd "ubuntu" /home/ubuntu/.vnc/passwd