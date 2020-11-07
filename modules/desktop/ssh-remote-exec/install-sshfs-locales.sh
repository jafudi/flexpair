#!/bin/sh -eux

sudo apt-get -qq update;
sudo -E apt-get -qq install software-properties-common
sudo apt-get -qq update;
sudo add-apt-repository universe
sudo apt-get -qq update
sudo -E apt-get -qq install sshfs locales
