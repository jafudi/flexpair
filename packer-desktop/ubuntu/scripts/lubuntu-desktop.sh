#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive" apt-get install -y lubuntu-desktop
DEBIAN_FRONTEND="noninteractive" dpkg-reconfigure sddm

reboot
