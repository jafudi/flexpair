#!/bin/sh -eux

export DEBIAN_FRONTEND="noninteractive"

# Clean and nuke the package from orbit
sudo rm -rf /var/log/unattended-upgrades;
sudo apt-get -qq purge unattended-upgrades snapd apport;
sudo apt-get -qq autoremove

# Update the package list
sudo apt-get -qq update;
sudo -E apt-get -qq install software-properties-common
sudo apt-get -qq update;
sudo add-apt-repository universe
sudo apt-get -qq update
sudo -E apt-get -qq install locales
