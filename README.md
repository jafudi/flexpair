# Getting Started Guide

Uses HashiCorp's open source [Packer](https://github.com/hashicorp/packer) tool and Chen-Han Hsiao's excellent [template library](https://github.com/chenhan1218/packer-desktop/tree/desktop/packer_templates/ubuntu) in order to install the [Lubuntu LXQt Desktop](https://lubuntu.me) on top of the official Ubuntu 20.04 Server ISO. Finally, the created [VirtualBox](https://www.virtualbox.org) VM is exported and uploaded to Vagrant Cloud as https://jafudi.net/vagrant-box.

Please install:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- [Gitlab Runner](https://docs.gitlab.com/runner/install)

Then, check out this repository and within the checked out folder run:

```
update_local_vm.sh
```
