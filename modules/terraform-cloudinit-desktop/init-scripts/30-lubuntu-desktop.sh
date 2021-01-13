#!/bin/bash -eux

export DEBIAN_FRONTEND="noninteractive"

apt-get -qq clean
apt-get -qq update --fix-missing > /dev/null

apt-get -qq install \
lubuntu-desktop \
libreoffice-draw libreoffice-impress libreoffice-base- \
gdm3- \
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
kdeconnect- \
snapd- \
acpi-support- \
screengrab- \
qps- \
qlipper- \
evince-

apt-get -qq install --no-install-recommends  \
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
usermod -aG nopasswdlogin "${DESKTOP_USERNAME}"

# lubuntu-desktop depends on (for installation)
apt-get -qq purge \
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
xscreensaver.*-

apt-get -qq autoremove

echo "Fertig mit 30-lubuntu-desktop.sh"
