#!/bin/sh -eux

msg='
This system is built by Jafudi Software
More information can be found at https://jafudi.com
Run "htop" for RAM usage information'


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
