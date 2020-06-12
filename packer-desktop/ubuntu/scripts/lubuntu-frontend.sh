#!/bin/bash -eux

apt-get clean
apt-get update --fix-missing

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
lxqt-about \
lxqt-admin \
lxqt-core \
lxqt-notificationd \
lxqt-openssh-askpass \
lxqt-policykit \
lxqt-powermanagement \
lxqt-sudo \
lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
accountsservice \
policykit-1 \
virtualbox-guest-x11 \
elementary-icon-theme \
locales \
nano \
less \
kdialog \
alsa-base \
alsa-utils \
arc-theme \
bc \
breeze-cursor-theme \
ca-certificates \
dbus-x11 \
desktop-file-utils \
fcitx \
fcitx-frontend-qt5 \
ffmpegthumbnailer \
fonts-dejavu-core \
fonts-freefont-ttf \
foomatic-db-compressed-ppds \
ghostscript-x \
gvfs-backends \
gvfs-fuse \
inputattach \
kde-style-breeze \
libfm-modules \
libmtp-runtime \
libqt5svg5 \
libsasl2-modules \
libu2f-udev \
lubuntu-artwork \
lubuntu-default-settings \
lubuntu-update-notifier \
modemmanager \
network-manager \
network-manager-gnome \
nm-tray \
obconf-qt \
openbox \
oxygen-icon-theme \
papirus-icon-theme \
pavucontrol-qt \
pcmanfm-qt \
pinentry-qt \
plymouth-theme-lubuntu-logo \
plymouth-theme-lubuntu-text \
printer-driver-gutenprint \
printer-driver-pnm2ppa \
pulseaudio \
python3-launchpadlib \
qterminal \
qttranslations5-l10n \
rfkill \
software-properties-qt \
spice-vdagent \
ubuntu-drivers-common \
ubuntu-mono \
unzip \
wvdial \
x11-utils \
xdg-user-dirs \
xfonts-efont-unicode \
xkb-data \
xorg \
xz-utils \
zip \
ark \
featherpad \
kcalc \
firefox \
trojita \
qpdfview \
lximage-qt \
gnumeric gnumeric-plugins-extra gnumeric-doc \
cutemaze
# 2048-qt \
# acpi-support \
# avahi-daemon \
# bluez \
# bluez-cups \
# compton-conf \
# cups \
# cups-bsd \
# cups-client \
# cups-filters \
# fwupd \
# fwupd-signed \
# hplip \
# htop \
# k3b \
# kerneloops \
# laptop-detect \
# libnss-mdns \
# libreoffice-calc \
# libreoffice-gtk3 \
# libreoffice-impress \
# libreoffice-qt5 \
# libreoffice-style-breeze \
# libreoffice-writer \
# memtest86+ \
# muon \
# neofetch \
# noblenote \
# packagekit \
# partitionmanager \
# pastebinit \
# plasma-discover \
# policykit-desktop-privileges \
# qapt-deb-installer \
# qlipper \
# qps \
# qtpass \
# quassel \
# screengrab \
# snapd \
# transmission-qt \
# zsync

cat << EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
autologin-user=ubuntu
autologin-user-timeout=5
EOF
systemctl enable lightdm.service
usermod -aG nopasswdlogin ubuntu


cat << EOF > /usr/lib/firefox/browser/defaults/preferences/sysprefs.js
pref("browser.startup.homepage","jafudi.com");
EOF

