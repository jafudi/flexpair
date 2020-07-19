#!/usr/bin/env bash

# https://wiki.ubuntuusers.de/Trojita/

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade trojita

MAILCONF=$HOME/.config/flaska.net
mkdir -p $MAILCONF
cat << EOF > $MAILCONF/trojita.conf
[General]
app.updates.checkEnabled=false
imap.auth.pass=JeedsEyruwiwez^
imap.auth.user=socialnets@jafudi.com
imap.capabilities.blacklist=
imap.host=s44.internetwerk.de
imap.method=TCP
imap.needsNetwork=true
imap.numberRefreshInterval=300
imap.port=143
imap.proxy.system=true
imap.startmode=ONLINE
imap.starttls=true
imapIdleRenewal=29
msa.method=SMTP
msa.smtp.auth=true
msa.smtp.auth.reuseImapCredentials=true
msa.smtp.auth.user=
msa.smtp.burl=false
msa.smtp.host=s44.internetwerk.de
msa.smtp.port=587
msa.smtp.starttls=true
offline.cache=days
offline.cache.numDays=30

[autoMarkRead]
enabled=true
seconds=0

[composer]
imapSentName=Sent Messages
saveToImapEnabled=true

[gui]
expandedMailboxes=INBOX
mailboxList.showOnlySubscribed=false
mainWindow.layout=compact
preferPlaintextRendering=false
showSystray=true
startMinimized=false

[identities]
1\address=socialnets@jafudi.com
1\organisation=
1\realName=Jafudi
1\signature=
size=1

[interoperability]
revealVersions=true

[plugin]
addressbook=abookaddressbook
password=cleartextpassword
EOF
chown ubuntu -R $MAILCONF