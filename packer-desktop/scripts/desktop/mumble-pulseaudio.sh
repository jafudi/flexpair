#!/usr/bin/env bash

# https://www.mumble.info
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade mumble

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
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
EOF
chown ubuntu -R $HOME/.config/pulse



