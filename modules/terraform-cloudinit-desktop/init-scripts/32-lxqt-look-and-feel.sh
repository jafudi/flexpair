#!/bin/bash -eux

echo "Running script lxqt-look-and-feel.sh..."
echo

chown -R "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}"

mkdir -p "/home/${DESKTOP_USERNAME}/Desktop"

qrencode -o "/home/${DESKTOP_USERNAME}/Desktop/Scan-To-Join.png" -s 6 -l H "${BROWSER_URL}"

cat << EOF > "/home/${DESKTOP_USERNAME}/.config/falkon/profiles/default/settings.ini"
[AddressBar]
CustomProgressColor="@Variant(\0\0\0\x43\x1\xff\xff==\xae\xae\xe9\xe9\0\0)"
ProgressStyle=0
SelectAllTextOnClick=true
SelectAllTextOnDoubleClick=true
ShowLoadingProgress=true
UseCustomProgressColor=false
alwaysShowGoIcon=false
showSuggestions=0
showSwitchTab=true
useInlineCompletion=true

[Browser-Tabs-Settings]
ActivateLastTabWhenClosingActual=true
AlwaysSwitchTabsWithWheel=false
AskOnClosing=false
OpenNewTabsSelected=false
OpenPopupsInTabs=true
TabsOnTop=true
dontCloseWithOneTab=false
hideTabsWithOneTab=false
newEmptyTabAfterActive=false
newTabAfterActive=true
showCloseOnInactiveTabs=1
showClosedTabsButton=true

[Browser-View-Settings]
LocationBarWidth=1268
SideBar=
SideBarWidth=141
WebSearchBarWidth=0
WebViewWidth=1411
instantBookmarksToolbar=false
settingsDialogPage=12
showBookmarksToolbar=false
showMenubar=false
showNavigationToolbar=true
showStatusBar=false

[DownloadManager]
CloseManagerOnFinish=true
ExternalManagerArguments=
ExternalManagerExecutable=
UseExternalManager=false
defaultDownloadPath=

[Language]
acceptLanguage=de-de, en-US, en

[NavigationBar]
Layout=button-backforward, button-reloadstop, button-home, locationbar, button-downloads, adblock-icon, button-tools
ShowSearchBar=false

[Notifications]
Enabled=true
Position=@Point(10 10)
Timeout=6000
UseNativeDesktop=true

[PasswordManager]
Backend=database

[Plugin-Settings]
AllowedPlugins=internal:adblock

[SearchEngines]
DefaultEngine=Google
SearchFromAddressBar=true
SearchWithDefaultEngine=true
activeEngine=Google
showSearchSuggestions=true

[SessionRestore]
isRestoring=false
isRunning=true

[Themes]
activeTheme=mac

[Web-Browser-Settings]
AllowLocalCache=true
AnimateScrolling=true
AutoCompletePasswords=true
AutomaticallyOpenProtocols=@Invalid()
BlockOpeningProtocols=@Invalid()
CachePath=/home/jfielenbach/.cache/falkon/default
CheckUpdates=true
DNSPrefetch=true
DefaultZoomLevel=6
DisableVideoAutoPlay=true
DoNotTrack=false
HTML5StorageEnabled=true
IncludeLinkInFocusChain=false
LoadTabsOnActivation=true
LocalCacheSize=50
PrintElementBackground=true
SavePasswordsOnSites=true
SpatialNavigation=false
UseNativeScrollbars=false
WebRTCPublicIpOnly=true
XSSAuditing=false
allowHistory=true
allowJavaScript=true
allowPlugins=true
closeAppWithCtrlQ=true
deleteCacheOnClose=false
deleteHTML5StorageOnClose=false
deleteHistoryOnClose=false
lastActiveSessionPath=../session.dat
userStyleSheet=
wheelScrollLines=3

[Web-URL-Settings]
afterLaunch=1
homepage=@Variant(\0\0\0\x11\0\0\0\x16https://www.google.de/)
newTabUrl=@Variant(\0\0\0\x11\0\0\0\x16https://www.google.de/)
EOF

cat << EOF > "/home/${DESKTOP_USERNAME}/Desktop/trash.desktop"
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

mkdir -p "/home/${DESKTOP_USERNAME}/.config/lxqt"
cat << EOF > "/home/${DESKTOP_USERNAME}/.config/lxqt/panel.conf"
[General]
__userfile__=true
iconTheme=
panels=panel1

[desktopswitch]
alignment=Left
labelType=1
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
apps\10\desktop=/usr/share/applications/vym.desktop
apps\11\desktop=/usr/share/applications/org.kde.falkon.desktop
apps\12\desktop=/usr/share/applications/libreoffice-calc.desktop
apps\13\desktop=/usr/share/applications/libreoffice-writer.desktop
apps\14\desktop=/usr/share/applications/codium.desktop
apps\2\desktop=/usr/share/applications/qterminal_drop.desktop
apps\3\desktop=/usr/share/applications/lxqt-config.desktop
apps\4\desktop=/usr/share/applications/mumble.desktop
apps\5\desktop=/usr/share/applications/pavucontrol-qt.desktop
apps\6\desktop=/usr/share/applications/com.github.wwmm.pulseeffects.desktop
apps\7\desktop=/usr/share/applications/simplescreenrecorder.desktop
apps\8\desktop=/usr/share/applications/trojita.desktop
apps\9\desktop=/usr/share/applications/org.gnome.clocks.desktop
apps\size=14
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

mkdir -p "/home/${DESKTOP_USERNAME}/.config/lxqt"
cat << EOF > "/home/${DESKTOP_USERNAME}/.config/lxqt/lxqt.conf"
[General]
__userfile__=true
icon_follow_color_scheme=true
icon_theme=ePapirus
single_click_activate=true
theme=Lubuntu Arc

[Qt]
style=Breeze
EOF

cat << EOF > "/home/${DESKTOP_USERNAME}/.config/lxqt/session.conf"
[General]
__userfile__=true
window_manager=openbox

[Environment]
BROWSER=falkon
GTK_CSD=0
GTK_OVERLAY_SCROLLING=0
TERM=qterminal
EOF

cat << EOF > "/home/${DESKTOP_USERNAME}/.config/lxqt/notifications.conf"
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

mkdir -p "/home/${DESKTOP_USERNAME}/.local/share/applications"
for f in $FILES
do
 echo "Processing $f"
 sed '/OnlyShowIn/aNoDisplay=true' < "/usr/share/applications/$f.desktop" >\
  "/home/${DESKTOP_USERNAME}/.local/share/applications/$f.desktop"
done

OCD="/home/${DESKTOP_USERNAME}/.config/openbox"
mkdir -p "$OCD" # Openbox Config Directory

# Remove namespace which complicates editing
sed 's/ xmlns.*=".*"//g' "/etc/xdg/openbox/lxqt-rc.xml" > "$OCD/lxqt-rc.xml"

apt-get install -qq xmlstarlet

# http://openbox.org/wiki/Help:Configuration
xmlstarlet ed \
--update "/openbox_config/focus/raiseOnFocus" --value "yes" \
--update "/openbox_config/placement/monitor" --value "Active" \
--update "/openbox_config/placement/primaryMonitor" --value "Active" \
--update "/openbox_config/theme/name" --value "Lubuntu Round" \
--update "/openbox_config/theme/titleLayout" --value "NLMSC" \
--update "/openbox_config/theme/animateIconify" --value "no" \
--subnode "/openbox_config/desktops/names" --type elem -n "name" -v "Front" \
--subnode "/openbox_config/desktops/names" --type elem -n "name" -v "Back" \
"$OCD/lxqt-rc.xml" > "$OCD/tmp.xml"

mv -f "$OCD/tmp.xml" "$OCD/lxqt-rc.xml"
