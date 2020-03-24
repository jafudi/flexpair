# Install a lightweight desktop
sudo apt-get clean
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends lubuntu-desktop

# Configure GRUB boot manager
echo 'GRUB_HIDDEN_TIMEOUT=10' | sudo tee -a /etc/default/grub
echo 'GRUB_HIDDEN_TIMEOUT_QUIET=true' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="ds=nocloud"' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' | sudo tee -a /etc/default/grub
echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
sudo rm -f /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub

# Remove password requirement
sudo passwd -d jafudi

sudo reboot
