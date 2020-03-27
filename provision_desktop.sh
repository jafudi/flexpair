# Install a lightweight desktop
sudo apt-get clean
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends lubuntu-desktop

# Purge Google cloud-init configuration and reinstall
sudo apt-get purge -y cloud-init
sudo rm -rf /etc/cloud/; sudo rm -rf /var/lib/cloud/
sudo apt-get install -y cloud-init
echo 'startx' | sudo tee -a /var/lib/cloud/scripts/per-boot/startx.sh
echo 'datasource_list: [ NoCloud, None ]' | sudo -s tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg
sudo dpkg-reconfigure -f noninteractive cloud-init

# Configure GRUB boot manager for desktop use
echo 'GRUB_CMDLINE_LINUX="ds=nocloud;seedfrom=https://raw.githubusercontent.com/jafudi/traction/master/cloud-init/"' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' | sudo tee -a /etc/default/grub
echo 'GRUB_HIDDEN_TIMEOUT=10' | sudo tee -a /etc/default/grub
echo 'GRUB_HIDDEN_TIMEOUT_QUIET=true' | sudo tee -a /etc/default/grub
echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
sudo rm -f /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub



