#!/bin/sh -eux

echo "Running script sshd.sh..."
echo

mkdir -p "/home/${DESKTOP_USERNAME}/.ssh"
touch "/home/${DESKTOP_USERNAME}/.ssh/vm_key"

cat <<EOF > /etc/ssh/sshd_config
Include /etc/ssh/sshd_config.d/*.conf

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
#PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# GSSAPI options
GSSAPIAuthentication no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes

AllowTcpForwarding yes
GatewayPorts yes
PrintMotd yes
UseDNS no

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server

# Override the global settings for guacd_container because Guacamole does not work with RSA private keys
Match address 172.18.0.2
    PasswordAuthentication yes
    PermitEmptyPasswords yes
    PermitRootLogin yes

Match address 127.0.0.1
    PasswordAuthentication yes
    PermitEmptyPasswords yes
    PermitRootLogin yes
EOF



