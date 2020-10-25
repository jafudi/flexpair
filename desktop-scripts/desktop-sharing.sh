#!/bin/bash -eux

echo "Running script desktop-sharing.sh..."
echo

# https://wiki.ubuntuusers.de/VNC/#VNC-Sitzung-gemeinsam-nutzen
# http://www.karlrunge.com/x11vnc/faq.html#faq
# https://wiki.archlinux.org/index.php/TigerVNC#Running_vncserver_for_virtual_(headless)_sessions
# https://wiki.ubuntuusers.de/VNC/#Manuell-ueber-SSH

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -qq install --no-install-recommends  \
x11vnc \
xvfb \
xserver-xorg-video-fbdev \
xserver-xorg-video-vesa \
xserver-xorg-video-dummy \
xserver-xorg-legacy \
xfonts-base

cat <<EOF | sudo tee /etc/systemd/system/x11vnc.service
[Unit]
Description=VNC server for X11
Wants=lightdm.service
After=lightdm.service

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -o /var/log/x11vnc.log -xkb -noxrecord -noxfixes -noxdamage -auth /var/run/lightdm/root/:0 -many -rfbport 5900 -passwd jafudi -localhost -shared
Restart=always
ExecStop=/usr/bin/x11vnc -R stop

[Install]
WantedBy=graphical.target
EOF
sudo systemctl enable x11vnc.service
sudo systemctl set-default graphical.target

sudo usermod -aG tty ubuntu

echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config

sudo mkdir -p /etc/X11
cat <<EOF | sudo tee /etc/X11/xorg.conf;
Section "Device"
    Identifier  "Dummy"
    Driver      "dummy"
    VideoRam    256000
    Option      "IgnoreEDID"    "true"
    Option      "NoDDC" "true"
EndSection

Section "Monitor"
    Identifier  "Monitor"
    HorizSync   15.0-100.0
    VertRefresh 15.0-200.0
EndSection

Section "Screen"
    Identifier  "Screen"
    Monitor     "Monitor"
    Device      "Dummy"
    DefaultDepth    24
    SubSection  "Display"
        Depth   24
        Modes   "1600x900" "1368x768"
    EndSubSection
EndSection
EOF
