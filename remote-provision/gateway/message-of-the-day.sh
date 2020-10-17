#!/bin/sh -eux

echo "Running script motd.sh..."
echo

sudo apt-get -qq update;
export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install --no-install-recommends glances

MOTD_CONFIG="/etc/update-motd.d"
mkdir -p ${MOTD_CONFIG}

cat << ASCIIART | sudo tee -a "${MOTD_CONFIG}/98-ascii-art"
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

cat << MESSAGE | sudo tee -a "${MOTD_CONFIG}/99-message"
#!/bin/sh
cat <<'EOF'

Welcome to your gateway :-)

For opening a performance monitor, enter:
"glances"

You may connect to the desktop host using:
"ssh -p 2222 ubuntu@127.0.0.1"
EOF
MESSAGE

sudo chmod -R 0755 ${MOTD_CONFIG}

