#!/usr/bin/env bash

cat << EOF > /etc/sddf.config
[Autologin]
# Whether sddm should automatically log back into sessions when they exit
Relogin=false

# Name of session file for autologin session (if empty try last logged in)
Session=Lubuntu.desktop

# Username for autologin session
User=vagrant
EOF