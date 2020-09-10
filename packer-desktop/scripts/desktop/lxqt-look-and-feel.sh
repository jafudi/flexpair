#!/usr/bin/env bash

mkdir -p $HOME/Desktop

cat << EOF > $HOME/Desktop/trash.desktop
[Desktop Entry]
Type=Application
Icon=user-trash
Name=Trash
Name[de]=Papierkorb
Comment=open trash
Categories=FileManager;Utility;Core;GTK;
Exec=pcmanfm-qt trash:///
StartupNotify=true
Terminal=false
MimeType=x-directory/normal;inode/directory;
EOF
chmod +x $HOME/Desktop/trash.desktop
chown ubuntu $HOME/Desktop/trash.desktop

mkdir -p $HOME/.config/lxqt
cat << EOF > $HOME/.config/lxqt/panel.conf
[General]
__userfile__=true
iconTheme=
panels=panel1

[desktopswitch]
alignment=Left
type=desktopswitch

[mainmenu]
alignment=Left
type=mainmenu

[mount]
type=mount

[panel1]
alignment=-1
animation-duration=0
background-color=@Variant(\0\0\0\x43\0\xff\xff\0\0\0\0\0\0\0\0)
background-image=
desktop=0
font-color=@Variant(\0\0\0\x43\0\xff\xff\0\0\0\0\0\0\0\0)
hidable=false
iconSize=32
lineCount=1
lockPanel=false
opacity=100
panelSize=48
plugins=mainmenu, desktopswitch, quicklaunch, taskbar, tray, statusnotifier
position=Right
reserve-space=true
show-delay=0
visible-margin=true
width=100
width-percent=true

[quicklaunch]
alignment=Left
apps\1\desktop=/usr/share/applications/pcmanfm-qt.desktop
apps\10\desktop=/usr/share/applications/gpodder.desktop
apps\11\desktop=/usr/share/applications/vlc.desktop
apps\12\desktop=/usr/share/applications/trojita.desktop
apps\13\desktop=/usr/share/applications/variety.desktop
apps\14\desktop=/usr/share/applications/qtqr.desktop
apps\15\desktop=/usr/share/applications/org.gnome.clocks.desktop
apps\2\desktop=/usr/share/applications/lxqt-config.desktop
apps\3\desktop=/usr/share/applications/qterminal.desktop
apps\4\desktop=/usr/share/applications/gnumeric.desktop
apps\5\desktop=/usr/share/applications/featherpad.desktop
apps\6\desktop=/usr/share/applications/mumble.desktop
apps\7\desktop=/usr/share/applications/pavucontrol-qt.desktop
apps\8\desktop=/usr/share/applications/simplescreenrecorder.desktop
apps\9\desktop=/usr/share/applications/tuxpaint.desktop
apps\size=15
type=quicklaunch

[showdesktop]
alignment=Right
type=showdesktop

[statusnotifier]
alignment=Right
type=statusnotifier

[taskbar]
alignment=Left
autoRotate=false
buttonHeight=100
buttonStyle=Icon
buttonWidth=400
closeOnMiddleClick=true
cycleOnWheelScroll=true
groupingEnabled=true
iconByClass=false
raiseOnCurrentDesktop=false
showDesktopNum=0
showGroupOnHover=true
showOnlyCurrentScreenTasks=false
showOnlyMinimizedTasks=true
showOnlyOneDesktopTasks=false
type=taskbar

[tray]
alignment=Right
type=tray

[volume]
device=0
type=volume
EOF

CONFIG_DIR=/home/ubuntu/.config
mkdir -p "${CONFIG_DIR}/lxqt"
cat << EOF > "${CONFIG_DIR}/lxqt/lxqt.conf"
[General]
__userfile__=true
icon_follow_color_scheme=true
icon_theme=ePapirus
single_click_activate=true
theme=Lubuntu Arc

[Qt]
style=Breeze
EOF

cat << EOF > "${CONFIG_DIR}/lxqt/session.conf"
[General]
__userfile__=true
window_manager=openbox

[Environment]
BROWSER=falkon
GTK_CSD=0
GTK_OVERLAY_SCROLLING=0
TERM=qterminal
EOF

cat << EOF > "${CONFIG_DIR}/lxqt/notifications.conf"
[General]
__userfile__=true
placement=bottom-left
EOF

cd /etc/xdg/autostart/
rm -f lxqt-globalkeyshortcuts.desktop
rm -f lxqt-powermanagement.desktop
rm -f lxqt-xscreensaver-autostart.desktop
rm -f nm-applet.desktop
rm -f nm-tray-autostart.desktop
rm -f snap-userd-autostart.desktop
rm -f upg-notifier-autostart.desktop

FILES="lxqt-hibernate
lxqt-leave
lxqt-lockscreen
lxqt-logout
lxqt-reboot
lxqt-shutdown
lxqt-suspend"

LOCAL_DIR=/home/ubuntu/.local
mkdir -p "${LOCAL_DIR}/share/applications"
for f in $FILES
do
 echo "Processing $f"
 sed '/OnlyShowIn/aNoDisplay=true' < "/usr/share/applications/$f.desktop" >\
  "${LOCAL_DIR}/share/applications/$f.desktop"
done


