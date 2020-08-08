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
kdialog \
alsa-base \
alsa-utils \
arc-theme \
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
paprefs \
pcmanfm-qt \
pinentry-qt \
plymouth-theme-lubuntu-logo \
plymouth-theme-lubuntu-text \
pulseaudio \
python3-launchpadlib \
qterminal \
qttranslations5-l10n \
rfkill \
gvfs-fuse \
gvfs-backends \
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
qpdfview \
lximage-qt \
gnumeric gnumeric-plugins-extra gnumeric-doc \
meteo-qt \
variety \
inkscape \
nextcloud-desktop \
linphone

mkdir -p $HOME/.config/meteo-qt
cat << EOF > $HOME/.config/meteo-qt/meteo-qt.conf
[General]
APPID=3e36578d41db7d1c3f085b272842a243
Autostart=False
Bold=False
CitiesTranslation={}
City=Heidelberg
CityList=['Heidelberg_DE_2907911']
Country=DE
FontSize=24
ID=2907911
Language=de
Proxy=False
StartMinimized=False
Tray=Temperature
TrayColor=#ffffff
TrayType=temp
Unit=metric
Wind_unit=km
EOF

# quite RAM hungry
# firefox \
# libreoffice
# cat << EOF > /usr/lib/firefox/browser/defaults/preferences/sysprefs.js
# pref("browser.startup.homepage","jafudi.com");
# EOF

mkdir -p $HOME/Desktop

mkdir -p /etc/lightdm
cat << EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
user-session=lxqt
greeter-session=lightdm-gtk-greeter
EOF
systemctl enable lightdm.service
usermod -aG nopasswdlogin ubuntu

mkdir -p $HOME/.config/lxqt
cat << EOF > $HOME/.config/lxqt/panel.conf
[General]
__userfile__=true

[desktopswitch]
alignment=Left
type=desktopswitch

[mainmenu]
alignment=Left
type=mainmenu

[panel1]
alignment=-1
animation-duration=0
background-color=@Variant(\0\0\0\x43\0\xff\xff\0\0\0\0\0\0\0\0)
background-image=
desktop=0
font-color=@Variant(\0\0\0\x43\0\xff\xff\0\0\0\0\0\0\0\0)
hidable=false
iconSize=22
lineCount=1
lockPanel=false
opacity=100
panelSize=32
plugins=mainmenu, desktopswitch, quicklaunch, taskbar, tray, statusnotifier, worldclock
position=Bottom
reserve-space=true
show-delay=0
visible-margin=true
width=100
width-percent=true

[quicklaunch]
alignment=Left
apps\1\desktop=/usr/share/applications/pcmanfm-qt.desktop
apps\2\desktop=/usr/share/applications/org.kde.kcalc.desktop
apps\3\desktop=/usr/share/applications/featherpad.desktop
apps\4\desktop=/usr/share/applications/qterminal.desktop
apps\5\desktop=/usr/share/applications/mumble.desktop
apps\6\desktop=/usr/share/applications/pavucontrol-qt.desktop
apps\7\desktop=/usr/share/applications/lximage-qt-screenshot.desktop
apps\8\desktop=/usr/share/applications/oneko.desktop
apps\size=8
type=quicklaunch

[statusnotifier]
alignment=Right
type=statusnotifier

[taskbar]
alignment=Left
type=taskbar

[tray]
alignment=Right
type=tray

[worldclock]
alignment=Right
type=worldclock
EOF
