#!/bin/bash -eux

NO_COMMENTS="70-murmur-config.sh"

cat << 'EOF' > "${NO_COMMENTS}"
#!/usr/bin/env bash

mkdir -p  "${MURMUR_CONFIG}"

cat << CONFIG > "${MURMUR_CONFIG}/murmur.ini"
EOF

# Murmur configuration file.
# 
# General notes:
# * Settings in this file are default settings and many of them can be overridden
#   with virtual server specific configuration via the Ice or DBus interface.
# * Due to the way this configuration file is read some rules have to be
#   followed when specifying variable values (as in variable = value):
#     * Make sure to quote the value when using commas in strings or passwords.
#        NOT variable = super,secret BUT variable = "super,secret"
#     * Make sure to escape special characters like '\' or '"' correctly
#        NOT variable = """ BUT variable = "\""
#        NOT regex = \w* BUT regex = \\w*

# Path to database. If blank, will search for
# murmur.sqlite in default locations or create it if not found.
cat << 'EOF' >> "${NO_COMMENTS}"
database=/opt/murmur/data/murmur.sqlite
EOF

# Murmur defaults to using SQLite with its default rollback journal.
# In some situations, using SQLite's write-ahead log (WAL) can be
# advantageous.
# If you encounter slowdowns when moving between channels and similar
# operations, enabling the SQLite write-ahead log might help.
# 
# To use SQLite's write-ahead log, set sqlite_wal to one of the following
# values:
# 
# 0 - Use SQLite's default rollback journal.
# 1 - Use write-ahead log with synchronous=NORMAL.
#     If Murmur crashes, the database will be in a consistent state, but
#     the most recent changes might be lost if the operating system did
#     not write them to disk yet. This option can improve Murmur's
#     interactivity on busy servers, or servers with slow storage.
# 2 - Use write-ahead log with synchronous=FULL.
#     All database writes are synchronized to disk when they are made.
#     If Murmur crashes, the database will be include all completed writes.
cat << 'EOF' >> "${NO_COMMENTS}"
;sqlite_wal=0
EOF

# If you wish to use something other than SQLite, you'll need to set the name
# of the database above, and also uncomment the below.
# Sticking with SQLite is strongly recommended, as it's the most well tested
# and by far the fastest solution.
cat << 'EOF' >> "${NO_COMMENTS}"
;dbDriver=QMYSQL
;dbUsername=
;dbPassword=
;dbHost=
;dbPort=
;dbPrefix=murmur_
;dbOpts=
EOF

# Murmur defaults to not using D-Bus. If you wish to use dbus, which is one of the
# RPC methods available in Murmur, please specify so here.
cat << 'EOF' >> "${NO_COMMENTS}"
;dbus=session
EOF

# Alternate D-Bus service name. Only use if you are running distinct
# murmurd processes connected to the same D-Bus daemon.
cat << 'EOF' >> "${NO_COMMENTS}"
;dbusservice=net.sourceforge.mumble.murmur
EOF

# If you want to use ZeroC Ice to communicate with Murmur, you need
# to specify the endpoint to use. Since there is no authentication
# with ICE, you should only use it if you trust all the users who have
# shell access to your machine.
# Please see the ICE documentation on how to specify endpoints.
cat << 'EOF' >> "${NO_COMMENTS}"
ice="tcp -h 127.0.0.1 -p 6502"
EOF

# Ice primarily uses local sockets. This means anyone who has a
# user account on your machine can connect to the Ice services.
# You can set a plaintext "secret" on the Ice connection, and
# any script attempting to access must then have this secret
# (as context with name "secret").
# Access is split in read (look only) and write (modify)
# operations. Write access always includes read access,
# unless read is explicitly denied (see note below).
# 
# Note that if this is uncommented and with empty content,
# access will be denied.
cat << 'EOF' >> "${NO_COMMENTS}"
;icesecretread=
icesecretwrite=
EOF

# If you want to expose Murmur's experimental gRPC API, you
# need to specify an address to bind on.
# Note: not all builds of Murmur support gRPC. If gRPC is not
# available, Murmur will warn you in its log output.
# Specifying both a certificate and key file below will cause gRPC to use
# secured, TLS connections.
cat << 'EOF' >> "${NO_COMMENTS}"
;grpc="127.0.0.1:50051"
;grpccert=""
;grpckey=""
EOF

# Specifies the file Murmur should log to. By default, Murmur
# logs to the file 'murmur.log'. If you leave this field blank
# on Unix-like systems, Murmur will force itself into foreground
# mode which logs to the console.
cat << 'EOF' >> "${NO_COMMENTS}"
logfile=/opt/murmur/log/murmur.log
EOF

# If set, Murmur will write its process ID to this file
# when running in daemon mode (when the -fg flag is not
# specified on the command line). Only available on
# Unix-like systems.
cat << 'EOF' >> "${NO_COMMENTS}"
;pidfile=
EOF

# The below will be used as defaults for new configured servers.
# If you're just running one server (the default), it's easier to
# configure it here than through D-Bus or Ice.
# 
# Welcome message sent to clients when they connect.
# If the welcome message is set to an empty string,
# no welcome message will be sent to clients.
cat << 'EOF' >> "${NO_COMMENTS}"
welcometext="If you cannot hear any sound e.g. when using Safari, please download the <a href=\"https://www.mumble.info/downloads/\" target=\"_blank\">Mumble app</a> and connect to server ${SSL_DOMAIN} on port ${MURMUR_PORT}.<br />"
EOF

# Port to bind TCP and UDP sockets to.
cat << 'EOF' >> "${NO_COMMENTS}"
port=${MURMUR_PORT}
EOF

# Specific IP or hostname to bind to.
# If this is left blank (default), Murmur will bind to all available addresses.
cat << 'EOF' >> "${NO_COMMENTS}"
;host=
EOF

# Password to join server.
cat << 'EOF' >> "${NO_COMMENTS}"
serverpassword=${MURMUR_PASSWORD}
EOF

# Maximum bandwidth (in bits per second) clients are allowed
# to send speech at.
cat << 'EOF' >> "${NO_COMMENTS}"
bandwidth=150000
EOF

# Murmur and Mumble are usually pretty good about cleaning up hung clients, but
# occasionally one will get stuck on the server. The timeout setting will cause
# a periodic check of all clients who haven't communicated with the server in
# this many seconds - causing zombie clients to be disconnected.
# 
# Note that this has no effect on idle clients or people who are AFK. It will
# only affect people who are already disconnected, and just haven't told the
# server.
cat << 'EOF' >> "${NO_COMMENTS}"
;timeout=30
EOF

# Maximum number of concurrent clients allowed.
cat << 'EOF' >> "${NO_COMMENTS}"
users=100
EOF

# Where users sets a blanket limit on the number of clients per virtual server,
# usersperchannel sets a limit on the number per channel. The default is 0, for
# no limit.
cat << 'EOF' >> "${NO_COMMENTS}"
;usersperchannel=0
EOF

# Per-user rate limiting
# 
# These two settings allow to configure the per-user rate limiter for some
# command messages sent from the client to the server. The messageburst setting
# specifies an amount of messages which are allowed in short bursts. The
# messagelimit setting specifies the number of messages per second allowed over
# a longer period. If a user hits the rate limit, his packages are then ignored
# for some time. Both of these settings have a minimum of 1 as setting either to
# 0 could render the server unusable.
cat << 'EOF' >> "${NO_COMMENTS}"
messageburst=5
messagelimit=1
EOF

# Respond to UDP ping packets.
# 
# Setting to true exposes the current user count, the maximum user count, and
# the server's maximum bandwidth per client to unauthenticated users. In the
# Mumble client, this information is shown in the Connect dialog.
cat << 'EOF' >> "${NO_COMMENTS}"
allowping=true
EOF

# Amount of users with Opus support needed to force Opus usage, in percent.
# 0 = Always enable Opus, 100 = enable Opus if it's supported by all clients.
cat << 'EOF' >> "${NO_COMMENTS}"
opusthreshold=0
EOF

# Maximum depth of channel nesting. Note that some databases like MySQL using
# InnoDB will fail when operating on deeply nested channels.
cat << 'EOF' >> "${NO_COMMENTS}"
;channelnestinglimit=10
EOF

# Maximum number of channels per server. 0 for unlimited. Note that an
# excessive number of channels will impact server performance
cat << 'EOF' >> "${NO_COMMENTS}"
;channelcountlimit=1000
EOF

# Regular expression used to validate channel names.
# (Note that you have to escape backslashes with \ )
cat << 'EOF' >> "${NO_COMMENTS}"
;channelname=[ \\-=\\w\\#\\[\\]\\{\\}\\(\\)\\@\\|]+
EOF

# Regular expression used to validate user names.
# (Note that you have to escape backslashes with \ )
cat << 'EOF' >> "${NO_COMMENTS}"
;username=[-=\\w\\[\\]\\{\\}\\(\\)\\@\\|\\.]+
EOF

# If a user has no stored channel (they've never been connected to the server
# before, or rememberchannel is set to false) and the client hasn't been given
# a URL that includes a channel path, the default behavior is that they will
# end up in the root channel.
# 
# You can set this setting to a channel ID, and the user will automatically be
# moved into that channel instead. Note that this is the numeric ID of the
# channel, which can be a little tricky to get (you'll either need to use an
# RPC mechanism, watch the console of a debug client, or root around through
# the Murmur Database to get it).
cat << 'EOF' >> "${NO_COMMENTS}"
;defaultchannel=0
EOF

# When a user connects to a server they've already been on, by default the
# server will remember the last channel they were in and move them to it
# automatically. Toggling this setting to false will disable that feature.
cat << 'EOF' >> "${NO_COMMENTS}"
;rememberchannel=true
EOF

# Maximum length of text messages in characters. 0 for no limit.
cat << 'EOF' >> "${NO_COMMENTS}"
;textmessagelength=5000
EOF

# Maximum length of text messages in characters, with image data. 0 for no limit.
cat << 'EOF' >> "${NO_COMMENTS}"
;imagemessagelength=131072
EOF

# Allow clients to use HTML in messages, user comments and channel descriptions?
cat << 'EOF' >> "${NO_COMMENTS}"
allowhtml=false
EOF

# Murmur retains the per-server log entries in an internal database which
# allows it to be accessed over D-Bus/ICE.
# How many days should such entries be kept?
# Set to 0 to keep forever, or -1 to disable logging to the DB.
cat << 'EOF' >> "${NO_COMMENTS}"
;logdays=31
EOF

# To enable public server registration, the serverpassword must be blank, and
# this must all be filled out.
# The password here is used to create a registry for the server name# subsequent
# updates will need the same password. Don't lose your password.
# The URL is your own website, and only set the registerHostname for static IP
# addresses.
# Location is typically the country of typical users of the server, in
# two-letter TLD style (ISO 3166-1 alpha-2 country code)
# 
# If you only wish to give your "Root" channel a custom name, then only
# uncomment the 'registerName' parameter.
cat << 'EOF' >> "${NO_COMMENTS}"
;registerName=Mumble Server
;registerPassword=secret
;registerUrl=http://www.mumble.info/
;registerHostname=
;registerLocation=
EOF

# If this option is enabled, the server will announce its presence via the
# bonjour service discovery protocol. To change the name announced by bonjour
# adjust the registerName variable.
# See http://developer.apple.com/networking/bonjour/index.html for more information
# about bonjour.
cat << 'EOF' >> "${NO_COMMENTS}"
bonjour=False
registerName="Everyone"
EOF

# If you have a proper SSL certificate, you can provide the filenames here.
# Otherwise, Murmur will create its own certificate automatically.
cat << 'EOF' >> "${NO_COMMENTS}"
sslCert=/opt/murmur/cert/fullchain.pem
sslKey=/opt/murmur/cert/privkey.pem
EOF

# If the keyfile specified above is encrypted with a passphrase, you can enter
# it in this setting. It must be plaintext, so you may wish to adjust the
# permissions on your murmur.ini file accordingly.
cat << 'EOF' >> "${NO_COMMENTS}"
;sslPassPhrase=
EOF

# If your certificate is signed by an authority that uses a sub-signed or
# "intermediate" certificate, you probably need to bundle it with your
# certificate in order to get Murmur to accept it. You can either concatenate
# the two certificates into one file, or you can put it in a file by itself and
# put the path to that PEM-file in sslCA.
cat << 'EOF' >> "${NO_COMMENTS}"
;sslCA=
EOF

# The sslDHParams option allows you to specify a PEM-encoded file with
# Diffie-Hellman parameters, which will be used as the default Diffie-
# Hellman parameters for all virtual servers.
# 
# Instead of pointing sslDHParams to a file, you can also use the option
# to specify a named set of Diffie-Hellman parameters for Murmur to use.
# Murmur comes bundled with the Diffie-Hellman parameters from RFC 7919.
# These parameters are available by using the following names:
# 
# @ffdhe2048, @ffdhe3072, @ffdhe4096, @ffdhe6144, @ffdhe8192
# 
# By default, Murmur uses @ffdhe2048.
cat << 'EOF' >> "${NO_COMMENTS}"
;sslDHParams=@ffdhe2048
EOF

# The sslCiphers option chooses the cipher suites to make available for use
# in SSL/TLS. This option is server-wide, and cannot be set on a
# per-virtual-server basis.
# 
# This option is specified using OpenSSL cipher list notation (see
# https://www.openssl.org/docs/apps/ciphers.html#CIPHER-LIST-FORMAT).
# 
# It is recommended that you try your cipher string using 'openssl ciphers <string>'
# before setting it here, to get a feel for which cipher suites you will get.
# 
# After setting this option, it is recommend that you inspect your Murmur log
# to ensure that Murmur is using the cipher suites that you expected it to.
# 
# Note: Changing this option may impact the backwards compatibility of your
# Murmur server, and can remove the ability for older Mumble clients to be able
# to connect to it.
cat << 'EOF' >> "${NO_COMMENTS}"
;sslCiphers=EECDH+AESGCM:EDH+aRSA+AESGCM:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:AES256-SHA:AES128-SHA
EOF

# If Murmur is started as root, which user should it switch to?
# This option is ignored if Murmur isn't started with root privileges.
cat << 'EOF' >> "${NO_COMMENTS}"
uname=murmur
EOF

# By default, in log files and in the user status window for privileged users,
# Mumble will show IP addresses - in some situations you may find this unwanted
# behavior. If obfuscate is set to true, Murmur will randomize the IP addresses
# of connecting users.
# 
# The obfuscate function only affects the log file and DOES NOT effect the user
# information section in the client window.
cat << 'EOF' >> "${NO_COMMENTS}"
;obfuscate=false
EOF

# If this options is enabled, only clients which have a certificate are allowed
# to connect.
cat << 'EOF' >> "${NO_COMMENTS}"
;certrequired=False
EOF

# If enabled, clients are sent information about the servers version and operating
# system.
cat << 'EOF' >> "${NO_COMMENTS}"
;sendversion=True
EOF

# You can set a recommended minimum version for your server, and clients will
# be notified in their log when they connect if their client does not meet the
# minimum requirements. suggestVersion expects the version in the format X.X.X.
# 
# Note that the suggest* options appeared after 1.2.3 and will have no effect
# on client versions 1.2.3 and earlier.
cat << 'EOF' >> "${NO_COMMENTS}"
;suggestVersion=
EOF

# Setting this to "true" will alert any user who does not have positional audio
# enabled that the server administrators recommend enabling it. Setting it to
# "false" will have the opposite effect - if you do not care whether the user
# enables positional audio or not, set it to blank. The message will appear in
# the log window upon connection, but only if the user's settings do not match
# what the server requests.
# 
# Note that the suggest* options appeared after 1.2.3 and will have no effect
# on client versions 1.2.3 and earlier.
cat << 'EOF' >> "${NO_COMMENTS}"
;suggestPositional=
EOF

# Setting this to "true" will alert any user who does not have Push-To-Talk
# enabled that the server administrators recommend enabling it. Setting it to
# "false" will have the opposite effect - if you do not care whether the user
# enables PTT or not, set it to blank. The message will appear in the log
# window upon connection, but only if the user's settings do not match what the
# server requests.
# 
# Note that the suggest* options appeared after 1.2.3 and will have no effect
# on client versions 1.2.3 and earlier.
cat << 'EOF' >> "${NO_COMMENTS}"
;suggestPushToTalk=
EOF

# This sets password hash storage to legacy mode (1.2.4 and before)
# (Note that setting this to true is insecure and should not be used unless absolutely necessary)
cat << 'EOF' >> "${NO_COMMENTS}"
;legacyPasswordHash=false
EOF

# By default a strong amount of PBKDF2 iterations are chosen automatically. If >0 this setting
# overrides the automatic benchmark and forces a specific number of iterations.
# (Note that you should only change this value if you know what you are doing)
cat << 'EOF' >> "${NO_COMMENTS}"
;kdfIterations=-1
EOF

# In order to prevent misconfigured, impolite or malicious clients from
# affecting the low-latency of other users, Murmur has a rudimentary global-ban
# system. It's configured using the autobanAttempts, autobanTimeframe and
# autobanTime settings.
# 
# If a client attempts autobanAttempts connections in autobanTimeframe seconds,
# they will be banned for autobanTime seconds. This is a global ban, from all
# virtual servers on the Murmur process. It will not show up in any of the
# ban-lists on the server, and they can't be removed without restarting the
# Murmur process - just let them expire. A single, properly functioning client
# should not trip these bans.
# 
# To disable, set autobanAttempts or autobanTimeframe to 0. Commenting these
# settings out will cause Murmur to use the defaults:
cat << 'EOF' >> "${NO_COMMENTS}"
;autobanAttempts=10
;autobanTimeframe=120
;autobanTime=300
EOF

# You can configure any of the configuration options for Ice here. We recommend
# leave the defaults as they are.
# Please note that this section has to be last in the configuration file.
cat << 'EOF' >> "${NO_COMMENTS}"

[Ice]
Ice.Warn.UnknownProperties=1
Ice.MessageSizeMax=65536
CONFIG
EOF
