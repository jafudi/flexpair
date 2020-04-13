#!/usr/bin/env bash

docker pull jafudi/idea-extractor:latest

DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends kdialog elementary-icon-theme
# https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/issues/418#issuecomment-295385819

cd /home/vagrant/
cp ./host/run_app.sh .
sudo chmod +x run_app.sh

cat << EOF | sudo tee ./Desktop/ideops.desktop
[Desktop Entry]
Type=Application
Terminal=true
Exec=/home/vagrant/run_app.sh
Icon=QMPlay2
Name=Hier klicken
EOF
sudo chmod +x ./Desktop/ideops.desktop
# does not work that way: dbus-launch gio set ./Desktop/ideops.desktop "metadata::trusted" yes