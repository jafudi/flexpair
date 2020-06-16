#!/bin/sh -eux

bento='
This system is built by Jafudi Software
More information can be found at https://jafudi.com'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-bento'

    cat >> "$MOTD_CONFIG" <<BENTO
#!/bin/sh

cat <<'EOF'
$bento
EOF
BENTO

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$bento" >> /etc/motd
fi
