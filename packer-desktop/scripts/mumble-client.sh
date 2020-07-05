#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade mumble

# https://www.mumble.info
# https://wiki.ubuntuusers.de/Mumble/

mkdir -p $HOME/.config/Mumble
cat << EOF > $HOME/.config/Mumble/Mumble.conf
[audio]
attenuateusersonpriorityspeak=true
echomulti=false
input=PulseAudio
noisesupress=0
output=PulseAudio
quality=96000
transmit=0
vadmax=@Variant(\0\0\0\x87?z\xe1\xf6)
vadmin=@Variant(\0\0\0\x87?L\xcd\x9a)
volume=@Variant(\0\0\0\x87\0\0\0\0)

[pulseaudio]
input=auto_null.monitor
output=auto_null
EOF
chown ubuntu -R $HOME/.config/Mumble

