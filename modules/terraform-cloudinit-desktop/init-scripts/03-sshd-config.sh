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

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
EOF
