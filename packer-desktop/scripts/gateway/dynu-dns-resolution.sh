#!/usr/bin/env bash

# https://www.dynu.com/DynamicDNS/IPUpdateClient/Linux

URL='https://www.dynu.com/support/downloadfile/31'; FILE=`mktemp`; wget "$URL" -qO $FILE \
&& sudo dpkg -i $FILE; rm $FILE

mkdir -p /etc/dynuiuc
cat <<EOF > /etc/dynuiuc/dynuiuc.conf;
username terraform
password quvka1-xesBut-nofxog
location
ipv4 true
ipv6 false
pollinterval 120
debug false
quiet false
EOF

systemctl enable dynuiuc.service
systemctl start dynuiuc.service