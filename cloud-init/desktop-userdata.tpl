Content-Type: multipart/mixed; boundary="====Part=Boundary================================================="
MIME-Version: 1.0

--====Part=Boundary=================================================
Content-Type: text/cloud-config; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.yaml"

#cloud-config

users:
  - default

# Set the system timezone
timezone: Europe/Berlin

locale: de_DE.UTF-8

mounts:
  - ["ubuntu@${SSL_DOMAIN}:/home/ubuntu", "/home/ubuntu/Desktop/Uploads"]

mount_default_fields:
  - "none"
  - "none"
  - "fuse.sshfs"
  - "nofail,noauto,_netdev,IdentityFile=/var/tmp/ssh/vm_key,x-systemd.automount,x-systemd.requires=cloud-init.service,allow_other,users,idmap=user"
  - "0"
  - "0"

# https://blog.luukhendriks.eu/2019/01/25/sshfs-too-many-levels-of-symbolic-links.html
runcmd:
    - "touch /home/ubuntu/Desktop/Uploads/can_write_as_root || echo  SSHFS mount not working yet. Try again later..."

--====Part=Boundary=================================================
Content-Type: text/x-shellscript; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="lubuntu-user-script.sh"

#!/usr/bin/env bash

# Check whether required packages are installed to proceed #########

packages=("docker.io" "kdialog" "mumble")

for pkg in ${packages[@]}; do
    is_pkg_installed=$(dpkg-query -W --showformat='${Status}\n' ${pkg} | grep "install ok installed")

    if [ "${is_pkg_installed}" == "install ok installed" ]; then
        echo ${pkg} is installed.
    else
        echo Missing package ${pkg}! Skip further execution.
        exit 0
    fi
done

# Obtain instance parameters / degrees of freedom ###################

function get_info() {
  curl --silent \
       -H "Authorization: Bearer Oracle" \
       "http://169.254.169.254/opc/v2/instance/$1"
}
export -f get_info
GATEWAY_DOMAIN=${SSL_DOMAIN}
GITLAB_RUNNER_TOKEN=`get_info metadata/gitlab-runner-token`

# Configure connection between desktop and gateway #################

cat << EOF > /etc/systemd/system/ssh-tunnel.service
[Unit]
Description=Reverse SSH connection
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ssh -vvv -g -N -T \
-o "ServerAliveInterval 10" \
-o "ExitOnForwardFailure yes" \
-o "StrictHostKeyChecking no" \
-i /var/tmp/ssh/vm_key \
-R 5900:localhost:5900 \
-R 6667:localhost:667 \
-R 2222:localhost:22 \
-R 4713:localhost:4713 \
-R 8000:localhost:8000 \
-L 64738:${GATEWAY_DOMAIN}:64738 \
ubuntu@${GATEWAY_DOMAIN}
Restart=always
RestartSec=5s

[Install]
WantedBy=default.target
EOF
systemctl enable ssh-tunnel.service
systemctl start ssh-tunnel.service

# Configure Mumble #################################################

# https://wiki.ubuntuusers.de/Mumble/
# https://wiki.natenom.de/mumble/benutzerhandbuch/mumble/variablen_mumble.ini

mkdir -p /home/ubuntu/.config/Mumble
cat << EOF > /home/ubuntu/.config/Mumble/Mumble.conf
[audio]
echomulti=false
headphone=true
input=PulseAudio
noisesupress=0
output=PulseAudio
outputdelay=10
quality=96000
vadmax=@Variant(\0\0\0\x87\x38\0\x1\0)
vadmin=@Variant(\0\0\0\x87\x38\0\x1\0)
voicehold=250

[codec]
opus/encoder/music=true

[net]
autoconnect=true
framesperpacket=6
jitterbuffer=5

[pulseaudio]
output=MumbleNullSink

[ui]
developermenu=true
WindowLayout=2
server=${GATEWAY_DOMAIN}
username=Desktop
showcontextmenuinmenubar=true
themestyle=Dark
stateintray=false
disablepubliclist=true
disableconnectdialogediting=false
EOF

# Deploy actual application ########################################

#DESKTOP=/home/ubuntu/Desktop
#mkdir -p $DESKTOP
#cat << EOF | sudo tee $DESKTOP/ideops.desktop
#[Desktop Entry]
#Type=Application
#Exec=qterminal --execute /var/tmp/run_app.sh
#Icon=QMPlay2
#Name=Hier klicken
#EOF
#sudo chmod +x $DESKTOP/ideops.desktop
#sudo chmod +x /var/tmp/run_app.sh
#
#docker pull --quiet jafudi/idea-extractor:latest &

# Is there an alternative to removing the user password ? ###########

sudo passwd -d ubuntu # for direct SSH access from guacd_container
chown ubuntu -R /home/ubuntu # handing over home folder to user

# Install GitLab runner ############################################

#echo "\n\nInstall Python packages required for testing on guest OS..."
#DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends python3-pip
#pip3 install setuptools
#pip3 install behave invoke jsonschema
#
#echo "\n\nInstall Gitlab Runnner for uploading artifacts from guest VM..."
#curl --silent -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
#apt-get install --upgrade -y gitlab-runner traceroute
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
#sudo gitlab-runner unregister --all-runners
#sudo rm -f /etc/gitlab-runner/config.toml
#
#DESCRIPTION="Shell executor on $(uname -s)"
#
#HOST_TAGS="$( \
#    hostnamectl \
#    | sed -E -e 's/^[ ]*//;s/[^a-zA-Z0-9\.]+/-/g;s/(.*)/\L\1/;' \
#    | tr '\n' ',' \
#)"
#
#ROUTE_TAGS="$( \
#    traceroute --max-hops=3 8.8.8.8 \
#    | sed -E -e '1d;s/^[ ]+[0-9][ ]+([a-zA-Z]+?).*/\1/;/^$/d;s/^/gateway-/' \
#    | tr '\n' ',' \
#)"
#
#sudo gitlab-runner register \
#--non-interactive \
#--url="https://gitlab.com/" \
#--registration-token="${GITLAB_RUNNER_TOKEN}" \
#--executor="shell" \
#--description="${DESCRIPTION}" \
#--tag-list="${HOST_TAGS},${ROUTE_TAGS}"
#
#sudo gitlab-runner restart
#sudo gitlab-runner status

# Install edutainment ##############################################

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
tuxmath tuxtype tuxpaint \
blockout2 \
kstars \
oneko \
frozen-bubble \
biniax2 \
funnyboat \

# http://www.tuxpaint.org/
# TODO: Switch to Japanese
cat << EOF > /home/ubuntu/.tuxpaintrc
fullscreen=yes
native=yes
noprint=yes
lang=japanese
EOF

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
bumprace \
cutemaze \
excellent-bifurcation \
icebreaker \
moon-lander \
snake4 \
tenmado \
gcompris \
gamine \
ri-li \
marble \
calibre \
xaos \
kmplot \
kalzium \
pencil2d \
stellarium \
gweled \
berusky \
epiphany \
koules \
liquidwar \
pacman \
performous \
solarwolf \
tecnoballz \
cgoban \
lmemory \
wesnoth

--====Part=Boundary=================================================--
