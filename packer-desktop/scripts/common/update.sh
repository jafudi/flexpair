#!/bin/sh -eux

echo "Block until cloud-init finished..."
set +e
cloud-init status --long --wait
sudo cat /var/log/cloud-init-output.log
set -e

ubuntu_version="`lsb_release -r | awk '{print $2}'`";
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

# Disable release-upgrades
sudo sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades;

# Disable systemd apt timers/services
sudo systemctl stop apt-daily.timer;
sudo systemctl stop apt-daily-upgrade.timer;
sudo systemctl disable apt-daily.timer;
sudo systemctl disable apt-daily-upgrade.timer;
sudo systemctl mask apt-daily.service;
sudo systemctl mask apt-daily-upgrade.service;
sudo systemctl daemon-reload;

# Disable periodic activities of apt to be safe
cat <<EOF | sudo tee /etc/apt/apt.conf.d/10periodic;
APT::Periodic::Enable "0";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

export DEBIAN_FRONTEND=noninteractive

# Clean and nuke the package from orbit
sudo rm -rf /var/log/unattended-upgrades;
sudo apt-get -y purge unattended-upgrades snapd apport;
sudo apt-get -y autoremove

# Update the package list
sudo apt-get -y update;

# Upgrade all installed packages incl. kernel and kernel headers
sudo apt-get -y dist-upgrade -o Dpkg::Options::="--force-confnew";

sudo apt-get -y update;
sudo apt-get -y install software-properties-common
sudo apt-get -y update;
sudo add-apt-repository universe
sudo apt-get -y update
sudo apt-get -y install sshfs less nano locales

sudo reboot

echo "Block until cloud-init finished..."
set +e
cloud-init status --long --wait
set -e
