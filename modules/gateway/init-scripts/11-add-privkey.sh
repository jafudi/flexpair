#!/bin/sh -eux

cat << EOF > "/home/${GATEWAY_USERNAME}/.ssh/vm_key"
${VM_PRIVATE_KEY}
EOF
chown "${GATEWAY_USERNAME}" "/home/${GATEWAY_USERNAME}/.ssh/vm_key"
chmod 600 "/home/${GATEWAY_USERNAME}/.ssh/vm_key"


