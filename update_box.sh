cd packer-desktop/ubuntu
packer build lubuntu-desktop-19.10-amd64.json
cd ../../
vagrant box add --force --name lubuntu19.10 builds/lubuntu-desktop-19.10.virtualbox.box