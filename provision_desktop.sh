sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop

# https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html
echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="scsi_mod.use_blk_mq=Y' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' | sudo tee -a /etc/default/grub
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
sudo rm -f /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub

sudo reboot