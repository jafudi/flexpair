#!/usr/bin/env bash

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

