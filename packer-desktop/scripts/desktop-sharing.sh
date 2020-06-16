#!/bin/bash -eux

# https://wiki.archlinux.org/index.php/TigerVNC#Running_vncserver_for_virtual_(headless)_sessions

DEBIAN_FRONTEND="noninteractive"

apt-get install -y --no-install-recommends --upgrade \
x11vnc \
xvfb \
xserver-xorg-video-fbdev \
xserver-xorg-video-vesa \
xserver-xorg-video-dummy \
xserver-xorg-legacy \
xfonts-base \
net-tools

cat <<EOF > /etc/systemd/system/x11vnc.service
[Unit]
Description=VNC server for X11
Wants=lightdm.service
After=lightdm.service

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -o /var/log/x11vnc.log -xkb -noxrecord -noxfixes -noxdamage -auth /var/run/lightdm/root/:0 -many -rfbport 5900 -passwd jafudi -shared
ExecStop=/usr/bin/x11vnc -R stop

[Install]
WantedBy=graphical.target
EOF
systemctl enable x11vnc.service
systemctl set-default graphical.target

#xinetd
#
#mkdir -p /etc/xinetd.d
#cat <<EOF > /etc/xinetd.d/x11vnc;
#service x11vncservice
#{
#       port            = 5900
#       type            = UNLISTED
#       socket_type     = stream
#       protocol        = tcp
#       wait            = no
#       user            = root
#       server          = /usr/bin/x11vnc
#       server_args     = -inetd -o /var/log/x11vnc.log -create -auth guess -passwd jafudi -rfbport 5900 -shared
#       disable         = no
#}
#EOF
#sudo /etc/init.d/xinetd reload

# The following three lines circumvent a hardly documented reject rule on Oracle Cloud provided images
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends iptables-persistent
iptables -I INPUT 1 -p tcp --dport 5900 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
netfilter-persistent save

usermod -aG tty ubuntu

echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

mkdir -p /etc/X11
cat <<EOF > /etc/X11/xorg.conf;
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
        Modes   "1920x1080" "1280x1024"
    EndSubSection
EndSection
EOF


#mkdir -p /home/ubuntu/.vnc
#x11vnc -storepasswd "ubuntu" /home/ubuntu/.vnc/passwd
#
#mkdir -p /home/ubuntu/.config/autostart
#
#cd /var/tmp
#rm -rf traction
#git clone --depth 1 https://github.com/jafudi/traction.git --branch master
#sudo chmod 777 -R traction
#cp /var/tmp/traction/autostart/* /home/ubuntu/.config/autostart/
#
#find /home/ubuntu/.config/autostart -type f -exec chmod +x {} \;
