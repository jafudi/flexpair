#!/bin/bash -eux

mkdir -p "/home/${DESKTOP_USERNAME}/.config/falkon/profiles/default"

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
