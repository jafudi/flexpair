#!/usr/bin/env bash

cd /var/tmp/traction
git pull
sudo chmod +x run_app.sh

cat << EOF | sudo tee ./Desktop/ideops.desktop
[Desktop Entry]
Type=Application
Terminal=true
Exec=/var/tmp/traction/run_app.sh
Icon=QMPlay2
Name=Hier klicken
EOF
sudo chmod +x ./Desktop/ideops.desktop

docker pull jafudi/idea-extractor:latest

