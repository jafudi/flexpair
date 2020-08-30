#!/bin/bash -eux

export DEBIAN_FRONTEND="noninteractive"

apt-get clean
apt-get update --fix-missing

apt-get install -y --no-install-recommends --upgrade lubuntu-desktop

apt-get purge -y \
anacron- \
bluedevil- \
genisoimage- \
lxqt-powermanagement- \
mobile-broadband-provider-info- \
modemmanager- \
openprinting-ppds- \
printer-driver-gutenprint- printer-driver-pnm2ppa- \
pulseaudio-module-bluetooth- \
rfkill- \
sddm- sddm-theme-lubuntu- \
ubuntu-release-upgrader-qt- \
usb-creator-kde- usb-modeswitch- \
whoopsie- apport- snapd- \
wireless-tools- wpasupplicant- \
xscreensaver- xscreensaver-data-extra- xscreensaver-gl- xscreensaver-gl-extra-

apt-get autoremove -y

apt-get install -y --no-install-recommends --upgrade \
kmag \
qtqr \
locales \
kdialog elementary-icon-theme \
htop \
ark \
featherpad \
falkon \
qpdfview \
lximage-qt \
gnumeric gnumeric-plugins-extra gnumeric-doc \
aspell \
variety \
nextcloud-desktop \
linphone \
gnome-clocks \
persepolis aria2 \
backintime-qt \
vym \
muon
