#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
build-essential \
python3-dev

pip3 install openslides

DESKTOP=/home/ubuntu/Desktop
mkdir -p $DESKTOP
cat << EOF | sudo tee $DESKTOP/openslides.desktop
[Desktop Entry]
Type=Application
Exec=qterminal --execute /home/ubuntu/.local/bin/openslides
Icon=QMPlay2
Name=OpenSlides
EOF
sudo chmod +x $DESKTOP/openslides.desktop