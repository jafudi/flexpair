#!/bin/bash -eux

export DEBIAN_FRONTEND="noninteractive"

apt-get clean
apt-get update --fix-missing

apt-get install -y --upgrade lubuntu-desktop \
gdm3-

apt-get install -y --no-install-recommends --upgrade \
lightdm \
lightdm-gtk-greeter \
lightdm-gtk-greeter-settings \
accountsservice \
policykit-1 policykit-desktop-privileges

mkdir -p /etc/lightdm
cat << EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
EOF
systemctl enable lightdm.service
usermod -aG nopasswdlogin ubuntu

apt-get purge -y \
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

apt-get autoremove -y
