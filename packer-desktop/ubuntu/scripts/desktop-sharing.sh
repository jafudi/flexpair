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
xterm \
net-tools \
iptables-persistent \
xinetd

mkdir -p /etc/xinetd.d
cat <<EOF > /etc/xinetd.d/x11vnc;
service x11vncservice
{
       port            = 5900
       type            = UNLISTED
       socket_type     = stream
       protocol        = tcp
       wait            = no
       user            = root
       server          = /usr/bin/x11vnc
       server_args     = -inetd -o /var/log/x11vnc.log -create -auth guess -passwd jafudi -rfbport 5900 -shared
       disable         = no
}
EOF
sudo /etc/init.d/xinetd reload

iptables -I INPUT 1 -p tcp --dport 5900 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
netfilter-persistent save

usermod -aG tty ubuntu

echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

mkdir -p /etc/X11/xorg.conf.d
cat <<EOF > /etc/X11/xorg.conf.d/10-headless.conf;
Section "Monitor"
        Identifier "dummy_monitor"
        HorizSync 28.0-80.0
        VertRefresh 48.0-75.0
        Modeline "1920x1080" 172.80 1920 2040 2248 2576 1080 1081 1084 1118
EndSection

Section "Device"
        Identifier "dummy_card"
        VideoRam 256000
        Driver "dummy"
EndSection

Section "Screen"
        Identifier "dummy_screen"
        Device "dummy_card"
        Monitor "dummy_monitor"
        SubSection "Display"
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
