#!/usr/bin/env bash

mkdir -p  "${GUACAMOLE_CONFIG}"

cat << 'EOF' > "${GUACAMOLE_CONFIG}/user-mapping.xml"
<user-mapping>

    <!-- Per-user authentication and config information -->
    <authorize username="guacadmin" password="guacadmin">

        <connection name="Aktiv mitarbeiten">
            <protocol>vnc</protocol>
            <param name="hostname">gateway</param>
            <param name="port">5900</param>
            <param name="username">jafudi</param>
            <param name="password">jafudi</param>
            <param name="enable-audio">false</param>
            <param name="enable-sftp">true</param>
            <param name="sftp-hostname">gateway</param>
            <param name="sftp-username">${GATEWAY_USERNAME}</param>
            <param name="sftp-directory">/home/${GATEWAY_USERNAME}/uploads</param>
            <param name="sftp-root-directory">/home/${GATEWAY_USERNAME}/uploads</param>
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

        <connection name="Gateway Administrations-Konsole">
            <protocol>ssh</protocol>
            <param name="hostname">gateway</param>
            <param name="username">${GATEWAY_USERNAME}</param>
            <param name="enable-sftp">true</param>
            <param name="sftp-root-directory">/home/${GATEWAY_USERNAME}/uploads</param>
            <param name="color-scheme">green-black</param>
        </connection>

        <connection name="Desktop Administrations-Konsole">
            <protocol>ssh</protocol>
            <param name="hostname">gateway</param>
            <param name="username">${GATEWAY_USERNAME}</param>
            <param name="enable-sftp">true</param>
            <param name="sftp-root-directory">/home/${GATEWAY_USERNAME}/uploads</param>
            <param name="color-scheme">gray-black</param>
            <param name="command">ssh -i /home/${GATEWAY_USERNAME}/.ssh/vm_key -p 2222 ${DESKTOP_USERNAME}@127.0.0.1</param>
        </connection>

    </authorize>

</user-mapping>
EOF
