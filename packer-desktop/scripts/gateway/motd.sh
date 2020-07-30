#!/bin/sh -eux

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade glances

msg='
Welcome to your gateway :-)

For opening a performance monitor, enter:
"glances"

You may connect to the desktop host using:
"ssh -p 2222 ubuntu@127.0.0.1"
'


if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-bento'

    cat >> "$MOTD_CONFIG" <<BENTO
#!/bin/sh

cat <<'EOF'
$msg
EOF
BENTO

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$msg" >> /etc/motd
fi
