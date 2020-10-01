#!/bin/bash -eux

export DEBIAN_FRONTEND="noninteractive"

sudo apt-get clean
sudo apt-get update --fix-missing

sudo apt-get install -y --upgrade lubuntu-desktop \
gdm3-

sudo apt-get install -y --no-install-recommends --upgrade \
lightdm \
lightdm-gtk-greeter \
lightdm-gtk-greeter-settings \
accountsservice \
policykit-1 policykit-desktop-privileges

sudo mkdir -p /etc/lightdm
cat << EOF | sudo tee /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
EOF
sudo systemctl enable lightdm.service
sudo usermod -aG nopasswdlogin ubuntu

sudo apt-get purge -y \
anacron- \
bluedevil- bluez- bluez-cups- pulseaudio-module-bluetooth- \
genisoimage- \
lxqt-powermanagement- \
mobile-broadband-provider-info- \
modemmanager- \
openprinting-ppds- \
printer.*- \
rfkill- \
sddm.*- \
ubuntu-release-upgrader-qt- \
usb.*- \
whoopsie- apport- \
wireless-tools- wpasupplicant- \
xscreensaver.*- \
avahi-daemon- \
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
skanlite- \
libreoffice-base- libreoffice-draw- \
kdeconnect- \
snapd- \
acpi-support- \
screengrab- \
qps- \
qlipper-

sudo apt-get autoremove -y
