#!/bin/bash -eux

DEBIAN_FRONTEND="noninteractive" apt-get autoremove -y --purge ubuntu-desktop kubuntu-desktop xubuntu-desktop
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends lubuntu-desktop gdm3- featherpad

reboot
