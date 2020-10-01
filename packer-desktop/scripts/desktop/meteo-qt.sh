#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get install -y --no-install-recommends --upgrade meteo-qt

mkdir -p $HOME/.config/meteo-qt
cat << EOF > $HOME/.config/meteo-qt/meteo-qt.conf
[General]
APPID=3e36578d41db7d1c3f085b272842a243
Autostart=False
Bold=False
CitiesTranslation={}
City=Heidelberg
CityList=['Heidelberg_DE_2907911']
Country=DE
FontSize=24
ID=2907911
Language=de
Proxy=False
StartMinimized=False
Tray=Temperature
TrayColor=#ffffff
TrayType=temp
Unit=metric
Wind_unit=km
EOF
