#!/bin/bash -eux

# Configure mail account ###########################################

# https://wiki.ubuntuusers.de/Trojita/

DEBIAN_FRONTEND="noninteractive" apt-get -qq install --no-install-recommends trojita

mkdir -p "/home/${DESKTOP_USERNAME}/.config/flaska.net"
cat << EOF > "/home/${DESKTOP_USERNAME}/.config/flaska.net/trojita.conf"
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

passwd -d "${DESKTOP_USERNAME}" # for direct SSH access from guacd_container

chown -R "${DESKTOP_USERNAME}" "/home/${DESKTOP_USERNAME}"
