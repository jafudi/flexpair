#!/bin/sh -eux

cat << EOF > "/home/${GATEWAY_USERNAME}/.ssh/vm_key"
${VM_PRIVATE_KEY}
EOF
chmod 600 "/home/${GATEWAY_USERNAME}/.ssh/vm_key"

chown -R "${GATEWAY_USERNAME}" "/home/${GATEWAY_USERNAME}"
