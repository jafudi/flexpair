#!/bin/bash -eux

echo "Running script sshd.sh..."
echo

cat <<EOF > /etc/ssh/sshd_config
# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# GSSAPI options
GSSAPIAuthentication no

# Set this to 'yes' to enable PAM authentication
UsePAM yes

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
EOF
