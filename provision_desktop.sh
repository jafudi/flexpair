sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ubuntu-desktop

setxkbmap -layout 'ch(de)'

echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
cat /etc/default/grub.d/40-force-partuuid.cfg
sudo rm -f /etc/default/grub.d/40-force-partuuid.cfg
sudo update-grub

sudo reboot