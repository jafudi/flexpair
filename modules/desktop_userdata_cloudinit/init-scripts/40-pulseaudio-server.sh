#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"
apt-get -qq install --no-install-recommends \
paprefs \
audacity

mkdir -p "/home/${DESKTOP_USERNAME}/.config/pulse"
cat << EOF > "/home/${DESKTOP_USERNAME}/.config/pulse/default.pa"
.include /etc/pulse/default.pa

load-module module-null-sink sink_name=DesktopAudio
update-sink-proplist DesktopAudio device.description=DesktopAudio
update-source-proplist DesktopAudio.monitor device.description=DesktopAudioMonitor

load-module module-null-sink sink_name=AudioConference
update-sink-proplist AudioConference device.description=AudioConference
update-source-proplist AudioConference.monitor device.description=AudioConferenceMonitor

set-default-sink DesktopAudio
set-default-source DesktopAudio.monitor

load-module module-native-protocol-tcp auth-anonymous=1
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
EOF

