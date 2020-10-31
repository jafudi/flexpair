#!/bin/sh -eux

export DEBIAN_FRONTEND="noninteractive"

# Clean and nuke the package from orbit
rm -rf /var/log/unattended-upgrades;
apt-get -qq purge unattended-upgrades snapd apport;
apt-get -qq autoremove

# Update the package list
apt-get -qq update;
apt-get -qq install software-properties-common
apt-get -qq update;
add-apt-repository universe
apt-get -qq update
apt-get -qq install locales
