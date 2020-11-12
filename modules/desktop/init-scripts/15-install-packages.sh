#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update;

apt-get -qq install software-properties-common
apt-get -qq update;

add-apt-repository universe
apt-get -qq update

apt-get -qq install \
less nano \
locales \
glances \
sshfs

rm -rf /var/log/unattended-upgrades
apt-get -qq purge unattended-upgrades snapd apport
apt-get -qq autoremove
