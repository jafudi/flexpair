#!/bin/bash -eux

mkdir -p  "${MURMUR_CONFIG}"

cat << CONFIG > "${MURMUR_CONFIG}/murmur.ini"
database=/opt/murmur/data/murmur.sqlite
;sqlite_wal=0
;dbDriver=QMYSQL
;dbUsername=
;dbPassword=
;dbHost=
;dbPort=
;dbPrefix=murmur_
;dbOpts=
;dbus=session
;dbusservice=net.sourceforge.mumble.murmur
ice="tcp -h 127.0.0.1 -p 6502"
;icesecretread=
icesecretwrite=
;grpc="127.0.0.1:50051"
;grpccert=""
;grpckey=""
logfile=/opt/murmur/log/murmur.log
;pidfile=
welcometext="If you cannot hear any sound e.g. when using Safari, please download the <a href=\"https://www.mumble.info/downloads/\" target=\"_blank\">Mumble app</a> and connect to server ${SSL_DOMAIN} on port ${MURMUR_PORT}.<br />"
port=${MURMUR_PORT}
;host=
serverpassword=${MURMUR_PASSWORD}
bandwidth=150000
;timeout=30
users=100
;usersperchannel=0
messageburst=5
messagelimit=1
allowping=true
opusthreshold=0
;channelnestinglimit=10
;channelcountlimit=1000
;channelname=[ \\-=\\w\\#\\[\\]\\{\\}\\(\\)\\@\\|]+
;username=[-=\\w\\[\\]\\{\\}\\(\\)\\@\\|\\.]+
;defaultchannel=0
;rememberchannel=true
;textmessagelength=5000
;imagemessagelength=131072
allowhtml=false
;logdays=31
;registerName=Mumble Server
;registerPassword=secret
;registerUrl=http://www.mumble.info/
;registerHostname=
;registerLocation=
bonjour=False
registerName="Everyone"
sslCert=/opt/murmur/cert/fullchain.pem
sslKey=/opt/murmur/cert/privkey.pem
;sslPassPhrase=
;sslCA=
;sslDHParams=@ffdhe2048
;sslCiphers=EECDH+AESGCM:EDH+aRSA+AESGCM:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:AES256-SHA:AES128-SHA
uname=murmur
;obfuscate=false
;certrequired=False
;sendversion=True
;suggestVersion=
;suggestPositional=
;suggestPushToTalk=
;legacyPasswordHash=false
;kdfIterations=-1
;autobanAttempts=10
;autobanTimeframe=120
;autobanTime=300

[Ice]
Ice.Warn.UnknownProperties=1
Ice.MessageSizeMax=65536
CONFIG
