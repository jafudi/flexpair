# Install a lightweight desktop
sudo apt-get clean
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y lubuntu-core

# Disable cloud-init as described in its documentation
echo 'GRUB_CMDLINE_LINUX_DEFAULT="text cloud-init=disabled network-config=disabled"' | sudo tee -a /etc/default/grub
sudo touch /etc/cloud/cloud-init.disabled

# Disable reference to partitions via UUID
echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg

# Remove other overwrites by Google Cloud Platform
sudo rm -f /etc/default/grub.d/50-cloudimg-settings.cfg

sudo update-grub
