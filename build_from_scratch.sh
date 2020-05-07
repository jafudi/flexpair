#!/usr/bin/env bash

vagrant destroy --force

# https://packer.io/docs/builders/virtualbox-iso.html
packer build -force -only=virtualbox-iso packer-desktop/ubuntu/pack-lubuntu.json

vagrant box remove --all Jafudi/ludopy
vagrant box add --clean --force Jafudi/ludopy packer-desktop/builds/lubuntu-docker-python.virtualbox.box

vagrant up

vagrant halt

if [ -z "$(git status --porcelain)" ]; then
    # Working directory clean
    cp oci_config ~/Library/VirtualBox/oci_config # on Mac

    vname="commit-$(git rev-parse --verify HEAD)"

    VBoxManage export lubuntu-docker-python \
    --output OCI:// \
    --cloud 0 \
    --vmname ${vname} \
    --cloudprofile JafudiOnOCI \
    --cloudbucket bucket-20200425-0937 \
    --cloudshape VM.Standard2.1 \
    --clouddomain iEUO:EU-FRANKFURT-1-AD-3 \
    --clouddisksize 64 \
    --cloudocivcn ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaasxbb7uqahhczda6xm5rwgph4lj2ojvz3wzxu2lzdpstkd2bogrda \
    --cloudocisubnet ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaaym5b7erow7ygf5msauzxgqwrs3vn6hjdwg2ebgght7azfjb7tjtq \
    --cloudkeepobject true \
    --cloudlaunchinstance true \
    --cloudpublicip true
else
  # Uncommitted changes
  echo "Commit any changes before proceeding."
fi

