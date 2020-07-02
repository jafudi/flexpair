#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
youtube-dl \
ffmpeg \
rtmpdump \
libqt5core5a \
libqt5gui5 \
libqt5widgets5 \
qtbase5-dev \
qtbase5-dev-tools \
g++

git clone https://github.com/rrooij/youtube-dl-qt.git
cd youtube-dl-qt
export QT_SELECT=qt5
qmake -config release
make

cat << EOF | sudo tee $HOME/Desktop/youtube-dl-qt.desktop
[Desktop Entry]
Encoding=UTF-8
Exec=/home/ubuntu/youtube-dl-qt/youtube-dl-qt
Name=Stream Downloader
Comment=Media downloader for many streaming sites
Terminal=false
Type=Application
Categories=AudioVideo;Audio;Video;
EOF
sudo chmod +x $HOME/Desktop/youtube-dl-qt.desktop

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
vlc \
mumble

mkdir -p /home/ubuntu/.config/Mumble
cat << EOF > /home/ubuntu/.config/Mumble/Mumble.conf
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

# too RAM hungry
#curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
#echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
#apt-get update && apt-get install -y --no-install-recommends spotify-client
