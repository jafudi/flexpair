#!/bin/bash -eux

cat << EOF > "/home/${GATEWAY_USERNAME}/.ssh/vm_key"
${VM_PRIVATE_KEY}
EOF
chown -R "${GATEWAY_USERNAME}" "/home/${GATEWAY_USERNAME}"
chmod 600 "/home/${GATEWAY_USERNAME}/.ssh/vm_key"


