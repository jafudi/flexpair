#!/bin/sh -eux

apt purge snapd --yes

apt-get remove -y whoopsie apport
apt-get -y autoremove

