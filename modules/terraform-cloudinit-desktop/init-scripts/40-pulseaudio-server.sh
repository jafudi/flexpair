#!/bin/bash -eux

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

# http://manpages.ubuntu.com/manpages/focal/man5/pulse-daemon.conf.5.html
cat << EOF > "/home/${DESKTOP_USERNAME}/.config/pulse/daemon.conf"
high-priority = yes
; nice-level = -11

realtime-scheduling = yes
; realtime-priority = 5

resample-method = soxr-hq
; avoid-resampling = false
; enable-remixing = yes
; remixing-use-all-sink-channels = yes
; remixing-produce-lfe = no
; remixing-consume-lfe = no

; default-sample-format = s16le
default-sample-rate = 48000
alternate-sample-rate = 48000
; default-sample-channels = 2
; default-channel-map = front-left,front-right

; enable-deferred-volume = yes
deferred-volume-safety-margin-usec = 1
; deferred-volume-extra-delay-usec = 0
EOF
