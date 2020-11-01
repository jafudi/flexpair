#!/usr/bin/env bash

mkdir -p  "${GUACAMOLE_CONFIG}"

cat << 'EOF' > "${GUACAMOLE_CONFIG}/user-mapping.xml"
<user-mapping>

    <!-- Per-user authentication and config information -->
    <authorize username="guacadmin" password="guacadmin">

        <!-- First authorized connection -->
        <connection name="Aktiv mitarbeiten">
            <protocol>vnc</protocol>
            <param name="hostname">gateway</param>
            <param name="port">5900</param>
            <param name="username">jafudi</param>
            <param name="password">jafudi</param>
            <param name="enable-audio">false</param>
            <param name="enable-sftp">true</param>
            <param name="sftp-hostname">gateway</param>
            <param name="sftp-username">ubuntu</param>
            <param name="sftp-directory">/home/ubuntu/uploads</param>
            <param name="sftp-root-directory">/home/ubuntu/uploads</param>
        </connection>

        <connection name="Zusehen und mitreden">
            <protocol>vnc</protocol>
            <param name="hostname">gateway</param>
            <param name="port">5900</param>
            <param name="username">jafudi</param>
            <param name="password">jafudi</param>
            <param name="read-only">true</param>
            <param name="enable-sftp">false</param>
            <param name="enable-audio">false</param>
            <param name="audio-servername">gateway</param>
            <param name="disable-copy">true</param>
            <param name="disable-paste">true</param>
        </connection>

        <!-- Second authorized connection -->
        <connection name="Administrations-Konsole">
            <protocol>ssh</protocol>
            <param name="hostname">gateway</param>
            <param name="username">ubuntu</param>
            <param name="enable-sftp">true</param>
            <param name="sftp-root-directory">/home/ubuntu/uploads</param>
        </connection>

    </authorize>

</user-mapping>
EOF