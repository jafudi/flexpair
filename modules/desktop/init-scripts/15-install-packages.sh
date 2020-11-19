#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update > /dev/null

apt-get -qq install software-properties-common
apt-get -qq update > /dev/null

add-apt-repository universe
apt-get -qq update > /dev/null

apt-get -qq install \
less nano \
locales \
glances \
build-essential \
sshfs

rm -rf /var/log/unattended-upgrades
apt-get -qq purge unattended-upgrades snapd apport
apt-get -qq autoremove
