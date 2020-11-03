#!/usr/bin/env bash

mkdir -p "/home/${GATEWAY_USERNAME}/uploads"
chown -R "${GATEWAY_USERNAME}" "/home/${GATEWAY_USERNAME}"

cat << EOF > "/home/${GATEWAY_USERNAME}/.ssh/vm_key"
${VM_PRIVATE_KEY}
EOF
chmod 600 "/home/${GATEWAY_USERNAME}/.ssh/vm_key"

mkdir -p /etc/update-motd.d

cat << 'ASCIIART' > "/etc/update-motd.d/98-ascii-art"
#!/bin/sh

cat <<'EOF'
                          _      _                                      _
/'\_/`\                  ( )    (_ )  _                  /'\_/`\       (_ )
|     | _   _   ___ ___  | |_    | | (_)  ___     __     |     |   _    | |    __
| (_) |( ) ( )/' _ ` _ `\| '_`\  | | | |/' _ `\ /'_ `\   | (_) | /'_`\  | |  /'__`\
| | | || (_) || ( ) ( ) || |_) ) | | | || ( ) |( (_) |   | | | |( (_) ) | | (  ___/
(_) (_)`\___/'(_) (_) (_)(_,__/'(___)(_)(_) (_)`\__  |   (_) (_)`\___/'(___)`\____)
                                               ( )_) |
                                                \___/'
 _                _____           ___            _
( )              (___  )        /'___)          ( ) _
| |_    _   _        | |   _ _ | (__  _   _    _| |(_)
| '_`\ ( ) ( )    _  | | /'_` )| ,__)( ) ( ) /'_` || |           _____
| |_) )| (_) |   ( )_| |( (_| || |   | (_) |( (_| || |         \"_   _"/
(_,__/'`\__, |   `\___/'`\__,_)(_)   `\___/'`\__,_)(_)         |(>)-(<)|
       ( )_| |                                              ../  " O "  \..      .|,
______ `\___/' ___ Jens Fielenbach, 2020 ________________-""(((:-.,_,.-:)))""-___\|/_

EOF
ASCIIART

cat << 'MESSAGE' > "/etc/update-motd.d/99-message"
#!/bin/sh

cat <<'EOF'

Welcome to your gateway :-)

For opening a performance monitor, enter:
"glances"

You may connect to the desktop host using:
"ssh -p 2222 ${GATEWAY_USERNAME}@127.0.0.1"

EOF
MESSAGE

chmod -R 0755 /etc/update-motd.d