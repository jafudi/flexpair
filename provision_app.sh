#!/usr/bin/env bash

docker pull jafudi/idea-extractor:latest

DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends kdialog

kdialog --passivepopup "Installed kdialog."

cd /home/vagrant/
cp ./host/run_app.sh ./Desktop/
sudo chmod +x ./Desktop/run_app.sh
