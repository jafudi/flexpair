sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop

echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
## https://help.ubuntu.com/community/Grub2/Setup#User_Settings:_.2Fetc.2Fdefault.2Fgrub
#sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
sudo update-grub

sudo reboot