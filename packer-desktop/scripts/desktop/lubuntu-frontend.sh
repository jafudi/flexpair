#!/bin/bash -eux

export DEBIAN_FRONTEND="noninteractive"

apt-get clean
apt-get update --fix-missing

apt-get install -y --upgrade lubuntu-desktop \
gdm3-

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
xscreensaver- xscreensaver-data-extra- xscreensaver-gl- xscreensaver-gl-extra- \
acpi-support- \
avahi-daemon- \
bluez- bluez-cups- \
firefox- \
fwupd- fwupd-signed- \
hplip- \
k3b- \
laptop-detect- \
libnss-mdns- \
memtest86+- \
noblenote- \
partitionmanager- \
pastebinit- \
pcmciautils- \
plasma-discover- \
printer-driver-.*- \
skanlite-

apt-get autoremove -y



