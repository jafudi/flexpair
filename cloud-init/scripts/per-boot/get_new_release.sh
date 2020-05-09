#!/usr/bin/env bash

qterminal -e "docker pull jafudi/idea-extractor:latest"

cd /home/vagrant
git clone --depth 1 https://github.com/jafudi/traction.git --branch master
sudo chmod +x ./traction/run_app.sh

cat << EOF | sudo tee ./Desktop/ideops.desktop
[Desktop Entry]
Type=Application
Terminal=true
Exec=/home/vagrant/traction/run_app.sh
Icon=QMPlay2
Name=Hier klicken
EOF
sudo chmod +x ./Desktop/ideops.desktop

