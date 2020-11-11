#!/usr/bin/env bash

mkdir -p "/home/${DESKTOP_USERNAME}/.ssh"

#cat << EOF > "/home/${DESKTOP_USERNAME}/.ssh/vm_key"
#${VM_PRIVATE_KEY}
#EOF
#chmod 600 "/home/${DESKTOP_USERNAME}/.ssh/vm_key"
#
#cat << EOF >> "/home/${DESKTOP_USERNAME}/.ssh/authorized_keys"
#${VM_PUBLIC_KEY}
#EOF
#chmod 600 "/home/${DESKTOP_USERNAME}/.ssh/authorized_keys"
#
#mkdir -p "/home/${DESKTOP_USERNAME}/Desktop/Uploads"
# chown -R "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}"