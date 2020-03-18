sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ubuntu-desktop

setxkbmap -layout 'ch(de)'

echo 'GRUB_DISABLE_LINUX_UUID=true' | sudo tee -a /etc/default/grub
sudo update-grub

sudo reboot