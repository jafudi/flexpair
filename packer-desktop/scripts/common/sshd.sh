#!/bin/sh -eux

SSHD_CONFIG="/etc/ssh/sshd_config"

# ensure that there is a trailing newline before attempting to concatenate
sed -i -e '$a\' "$SSHD_CONFIG"

GATEWAY="GatewayPorts yes"
if grep -q -E "^[[:space:]]*GatewayPorts" "$SSHD_CONFIG"; then
    sed -i "s/^\s*GatewayPorts.*/${GATEWAY}/" "$SSHD_CONFIG"
else
    echo "$GATEWAY" >>"$SSHD_CONFIG"
fi

FORWARDING="AllowTcpForwarding all"
if grep -q -E "^[[:space:]]*AllowTcpForwarding" "$SSHD_CONFIG"; then
    sed -i "s/^\s*AllowTcpForwarding.*/${FORWARDING}/" "$SSHD_CONFIG"
else
    echo "$FORWARDING" >>"$SSHD_CONFIG"
fi

USEDNS="UseDNS no"
if grep -q -E "^[[:space:]]*UseDNS" "$SSHD_CONFIG"; then
    sed -i "s/^\s*UseDNS.*/${USEDNS}/" "$SSHD_CONFIG"
else
    echo "$USEDNS" >>"$SSHD_CONFIG"
fi

GSSAPI="GSSAPIAuthentication no"
if grep -q -E "^[[:space:]]*GSSAPIAuthentication" "$SSHD_CONFIG"; then
    sed -i "s/^\s*GSSAPIAuthentication.*/${GSSAPI}/" "$SSHD_CONFIG"
else
    echo "$GSSAPI" >>"$SSHD_CONFIG"
fi



