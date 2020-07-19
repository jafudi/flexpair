#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
bumprace \
cutemaze \
excellent-bifurcation \
icebreaker \
moon-lander \
snake4 \
tenmado \
blockout2 \
kstars \
gcompris \
tuxmath tuxtype tuxpaint \
gamine \
ri-li \
marble \
calibre \
xaos \
kmplot \
kalzium \
pencil2d \
oneko \
kstars stellarium \
frozen-bubble \
gweled \
berusky \
epiphany \
biniax2 \
funnyboat \
koules \
liquidwar \
pacman \
performous \
solarwolf \
tecnoballz \
cgoban \
lmemory \
wesnoth

# needs more RAM, otherwise good application
# wget -O ~/google-earth.deb https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
# sudo dpkg -i ~/google-earth.deb

# http://www.tuxpaint.org/
# TODO: Switch to Japanese
cat << EOF > $HOME/.tuxpaintrc
fullscreen=yes
native=yes
noprint=yes
lang=japanese
EOF