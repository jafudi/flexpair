sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ubuntu-desktop

echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' | sudo tee -a /etc/default/grub
echo '/etc/default/grub:'
cat /etc/default/grub
echo 'Delete /etc/default/grub.d/40-force-partuuid.cfg:'
cat /etc/default/grub.d/40-force-partuuid.cfg
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
echo 'Delete /etc/default/grub.d/50-cloudimg-settings.cfg:'
cat /etc/default/grub.d/50-cloudimg-settings.cfg
sudo rm -f /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub

sudo reboot