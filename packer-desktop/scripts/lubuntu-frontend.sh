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
lxqt-sudo \
lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
accountsservice \
policykit-1 \
virtualbox-guest-x11 \
elementary-icon-theme \
locales \
cron \
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
htop \
ark \
featherpad \
kcalc \
falkon \
trojita \
qpdfview \
lximage-qt \
gnumeric gnumeric-plugins-extra gnumeric-doc \
cutemaze \
2048-qt \
blockout2

# quite RAM hungry
# firefox \
# libreoffice

mkdir -p $HOME/Desktop
chown ubuntu -R $HOME

cat << EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
EOF
systemctl enable lightdm.service
usermod -aG nopasswdlogin ubuntu

cd /etc/xdg/autostart/
rm -f lxqt-globalkeyshortcuts.desktop
rm -f lxqt-powermanagement.desktop
rm -f lxqt-xscreensaver-autostart.desktop
rm -f nm-applet.desktop
rm -f nm-tray-autostart.desktop
rm -f snap-userd-autostart.desktop
rm -f upg-notifier-autostart.desktop


cat << EOF > /usr/lib/firefox/browser/defaults/preferences/sysprefs.js
pref("browser.startup.homepage","jafudi.com");
EOF

