#!/bin/sh -eux

echo "Running script motd.sh..."
echo

sudo apt-get -y -qq update;
export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -y install -qq --no-install-recommends glances

img=$(cat /var/tmp/ascii-art)

msg='
Welcome to your gateway :-)

For opening a performance monitor, enter:
"glances"

You may connect to the desktop host using:
"ssh -p 2222 ubuntu@127.0.0.1"
'


if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-bento'

cat << BENTO | sudo tee -a "$MOTD_CONFIG"
#!/bin/sh

cat <<'EOF'
$img
$msg
EOF
BENTO

    sudo chmod 0755 "$MOTD_CONFIG"
else
    echo "$msg" | sudo tee -a /etc/motd
fi
