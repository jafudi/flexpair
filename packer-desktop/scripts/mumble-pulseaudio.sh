#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade mumble iputils-ping

# https://www.mumble.info
# https://wiki.ubuntuusers.de/Mumble/

mkdir -p $HOME/.config/pulse
cat << EOF > $HOME/.config/pulse/default.pa
.include /etc/pulse/default.pa

load-module module-null-sink sink_name=AllExceptMumble
update-sink-proplist AllExceptMumble device.description=AllExceptMumble

set-default-sink AllExceptMumble
set-default-source AllExceptMumble.monitor

load-module module-null-sink sink_name=MumbleNullSink
update-sink-proplist MumbleNullSink device.description=MumbleNullSink

load-module module-native-protocol-tcp auth-anonymous=1
EOF
chown ubuntu -R $HOME/.config/pulse

mkdir -p $HOME/.config/Mumble
cat << EOF > $HOME/.config/Mumble/Mumble.conf
[audio]
echomulti=false
headphone=true
input=PulseAudio
noisesupress=0
output=PulseAudio
outputdelay=10
quality=96000
vadmax=@Variant(\0\0\0\x87\x38\0\x1\0)
vadmin=@Variant(\0\0\0\x87\x38\0\x1\0)
voicehold=250

[codec]
opus/encoder/music=true

[net]
autoconnect=true
framesperpacket=6
jitterbuffer=5

[pulseaudio]
output=MumbleNullSink

[ui]
developermenu=true
WindowLayout=2
server=158.101.175.18
showcontextmenuinmenubar=true
themestyle=Dark
stateintray=false
EOF
chown ubuntu -R $HOME/.config/Mumble

