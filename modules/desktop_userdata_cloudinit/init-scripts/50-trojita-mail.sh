#!/usr/bin/env bash

# Configure mail account ###########################################

# https://wiki.ubuntuusers.de/Trojita/

DEBIAN_FRONTEND="noninteractive" apt-get -qq install --no-install-recommends trojita

mkdir -p "/home/${DESKTOP_USERNAME}/.config/flaska.net"
cat << EOF > /home/${DESKTOP_USERNAME}/.config/flaska.net/trojita.conf
[General]
app.updates.checkEnabled=false
imap.auth.pass=${IMAP_PASSWORD}
imap.auth.user=${EMAIL_ADDRESS}
imap.capabilities.blacklist=
imap.host=localhost
imap.method=TCP
imap.needsNetwork=true
imap.numberRefreshInterval=300
imap.port=143
imap.proxy.system=true
imap.startmode=ONLINE
imap.starttls=true
imapIdleRenewal=29
msa.method=SMTP
msa.smtp.auth=false
msa.smtp.auth.reuseImapCredentials=false
msa.smtp.auth.user=
msa.smtp.burl=false
msa.smtp.host=localhost
msa.smtp.port=25
msa.smtp.starttls=false
offline.cache=days
offline.cache.numDays=30

[autoMarkRead]
enabled=true
seconds=0

[composer]
imapSentName=Sent
saveToImapEnabled=true

[gui]
expandedMailboxes=INBOX
mailboxList.showOnlySubscribed=false
mainWindow.layout=compact
preferPlaintextRendering=false
showSystray=false
startMinimized=false

[identities]
1\address=${EMAIL_ADDRESS}
1\organisation=
1\signature=
size=1

[interoperability]
revealVersions=true

[plugin]
addressbook=abookaddressbook
password=cleartextpassword
EOF
chown "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}/.config/flaska.net/trojita.conf"

# Deploy DevOps application ########################################

#DESKTOP=/home/${DESKTOP_USERNAME}/Desktop
#mkdir -p $DESKTOP
#cat << EOF > $DESKTOP/ideops.desktop
#[Desktop Entry]
#Type=Application
#Exec=qterminal --execute /var/tmp/run_app.sh
#Icon=QMPlay2
#Name=Hier klicken
#EOF
#chmod +x $DESKTOP/ideops.desktop
#chmod +x /var/tmp/run_app.sh
#
#docker pull --quiet jafudi/idea-extractor:latest &

# Install GitLab runner ############################################

#echo "\n\nInstall Python packages required for testing on guest OS..."
#DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends python3-pip
#pip3 install setuptools
#pip3 install behave invoke jsonschema
#
#echo "\n\nInstall Gitlab Runnner for uploading artifacts from guest VM..."
#curl --silent -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash
#apt-get -qq install gitlab-runner traceroute
#
#echo 'gitlab-runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#usermod -aG docker gitlab-runner
#
#cd /home/gitlab-runner
#mkdir -p builds
#chmod --recursive 777 builds
#rm -f .bash_logout
#
## Register GitLab runner ###########################################
#
#gitlab-runner unregister --all-runners
# rm -f /etc/gitlab-runner/config.toml
#
#gitlab-runner register \
#--non-interactive \
#--url="https://gitlab.com/" \
#--registration-token="$(get_info metadata/gitlab-runner-token)" \
#--executor="shell" \
#--description="Shell executor on $(uname -s)" \
#--tag-list="$( \
#    hostnamectl \
#    | sed -E -e 's/^[ ]*//;s/[^a-zA-Z0-9\.]+/-/g;s/(.*)/\L\1/;' \
#    | tr '\n' ',' \
#)","$( \
#    traceroute --max-hops=3 8.8.8.8 \
#    | sed -E -e '1d;s/^[ ]+[0-9][ ]+([a-zA-Z]+?).*/\1/;/^$/d;s/^/gateway-/' \
#    | tr '\n' ',' \
#)"
#
#gitlab-runner restart
#gitlab-runner status

passwd -d "${DESKTOP_USERNAME}" # for direct SSH access from guacd_container

chown -R "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}"
