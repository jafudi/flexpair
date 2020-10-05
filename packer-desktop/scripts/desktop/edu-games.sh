#!/usr/bin/env bash

echo "Running script edu-games.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -y install -qq --no-install-recommends \
2048-qt \
blockout2 \
kstars \
oneko \
frozen-bubble \
biniax2 \
fraqtive \
dossizola \
ksudoku \
blinken \
amoebax \
kmplot kalzium \
cgoban \
cutemaze \
lmemory \
ri-li \
monsterz monsterz-data \
kdegames

sudo -E apt-get -y install -qq tuxmath tuxpaint
# https://wiki.ubuntuusers.de/Tux_Paint/
sudo mkdir -p /etc/tuxpaint/
cat << EOF | sudo tee /etc/tuxpaint/tuxpaint.conf
fullscreen=native
noshortcuts=yes
alllocalefonts=yes
noprint=yes
savedir=/home/ubuntu/Desktop/Uploads/
EOF
sudo chown -R ubuntu /etc/tuxpaint/
