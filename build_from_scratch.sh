#!/usr/bin/env bash

#vagrant destroy --force
#
#PACKER_LOG=1
#PACKER_LOG_PATH="packer-desktop/builds"
## https://packer.io/docs/builders/virtualbox-iso.html

# ssh-keygen -t rsa -N "" -b 2048 -C "my_vm_key" -f ~/.oci/oci_vm_key

packer build -color=true -on-error=abort packer-desktop/ubuntu/pack-lubuntu.json

#vagrant box remove --all Jafudi/ludopy
#vagrant box add --clean --force Jafudi/ludopy packer-desktop/builds/lubuntu-docker-python.virtualbox.box
#
#vagrant up
#
#vagrant halt
#
#vagrant up # comment out when intending to export to OCI
#
#if [ -z "$(git status --porcelain)" ]; then
#    # Working directory clean
#    cp oci_config ~/Library/VirtualBox/oci_config # on Mac
#
#    vm_name="traction-commit-$(git rev-parse --verify HEAD)"
#    echo "Assign machine name ${vm_name}..."
#
#    VBoxManage export lubuntu-docker-python \
#    --output OCI:// \
#    --cloud 0 \
#    --vmname ${vm_name} \
#    --cloudprofile JafudiOnOCI \
#    --cloudbucket bucket-20200425-0937 \
#    --cloudshape VM.Standard2.1 \
#    --clouddomain iEUO:EU-FRANKFURT-1-AD-3 \
#    --clouddisksize 64 \
#    --cloudocivcn ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaasxbb7uqahhczda6xm5rwgph4lj2ojvz3wzxu2lzdpstkd2bogrda \
#    --cloudocisubnet ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaaym5b7erow7ygf5msauzxgqwrs3vn6hjdwg2ebgght7azfjb7tjtq \
#    --cloudkeepobject true \
#    --cloudlaunchinstance true \
#    --cloudpublicip true
#else
#  # Uncommitted changes
#  echo "Commit any changes before proceeding."
#fi

