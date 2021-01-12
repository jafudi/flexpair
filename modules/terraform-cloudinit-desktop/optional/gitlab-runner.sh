#!/bin/bash -eux

# Deploy DevOps application ########################################

# install kdialog elementary-icon-theme

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
