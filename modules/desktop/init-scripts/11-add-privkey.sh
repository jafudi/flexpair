#!/bin/sh -eux

cat << EOF > /home/${DESKTOP_USERNAME}/.ssh/vm_key
${VM_PRIVATE_KEY}
EOF
chown "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}/.ssh/vm_key"
chmod 600 "/home/${DESKTOP_USERNAME}/.ssh/vm_key"
