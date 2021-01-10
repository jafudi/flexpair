#!/bin/bash -eux

mkdir -p  "${MURMUR_CONFIG}"

cat << CONFIG > "${MURMUR_CONFIG}/murmur.ini"
database=/opt/murmur/data/murmur.sqlite
ice="tcp -h 127.0.0.1 -p 6502"
icesecretwrite=
logfile=/opt/murmur/log/murmur.log
welcometext="If you cannot hear any sound e.g. when using Safari, please download the <a href=\"https://www.mumble.info/downloads/\" target=\"_blank\">Mumble app</a> and connect to server ${SSL_DOMAIN} on port ${MURMUR_PORT}.<br />"
port=${MURMUR_PORT}
serverpassword=${MURMUR_PASSWORD}
bandwidth=150000
users=100
messageburst=5
messagelimit=1
allowping=true
opusthreshold=0
allowhtml=false
bonjour=False
registerName="Everyone"
sslCert=/opt/murmur/cert/fullchain.pem
sslKey=/opt/murmur/cert/privkey.pem
uname=murmur

[Ice]
Ice.Warn.UnknownProperties=1
Ice.MessageSizeMax=65536
CONFIG
