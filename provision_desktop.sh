sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop

## https://help.ubuntu.com/community/Grub2/Setup#User_Settings:_.2Fetc.2Fdefault.2Fgrub
echo '/etc/default/grub:'
cat /etc/default/grub
echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="scsi_mod.use_blk_mq=Y' | sudo tee -a /etc/default/grub
echo '/etc/default/grub.d/40-force-partuuid.cfg:'
cat /etc/default/grub.d/40-force-partuuid.cfg
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
echo '/etc/default/grub.d/50-cloudimg-settings.cfg:'
cat /etc/default/grub.d/50-cloudimg-settings.cfg
sudo rm -f /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub

sudo reboot