# Getting Started Guide

Uses HashiCorp's open source [Packer](https://github.com/hashicorp/packer) tool and Chen-Han Hsiao's excellent [template library](https://github.com/chenhan1218/packer-desktop/tree/desktop/packer_templates/ubuntu) in order to install the [Lubuntu LXQt Desktop](https://lubuntu.me) on top of the official [`ubuntu-19.10-server-amd64.iso`](http://cdimage.ubuntu.com/releases/19.10/release/). Finally, the created [VirtualBox](https://www.virtualbox.org) VM is exported and uploaded to Vagrant Cloud as https://jafudi.net/vagrant-box.

## Production Environment
Please install the following two pieces of software on the host computer:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

Then, check out this repository and within the checked out folder run:

`vagrant up --provision-with prod`

## Test / Staging Environment

Please install the following two pieces of software on the host computer:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- [Gitlab Runner](https://docs.gitlab.com/runner/install)

Then, check out this repository and within the checked out folder run:

```
vagrant up
gitlab-runner start
gitlab-runner unregister --all-runners
gitlab-runner register \
    --non-interactive \
    --url="https://gitlab.com/" \
    --registration-token="JW6YYWLG4mTsr_-mSaz8" \
    --executor="virtualbox" \
    --description="lubuntu-docker-python" \
    --tag-list="virtualbox" \
    --virtualbox-base-name="lubuntu-docker-python" \
    --virtualbox-disable-snapshots="false" \
    --ssh-user="vagrant" \
    --ssh-password="vagrant" \
    --ssh-identity-file="$PWD/.vagrant/machines/default/virtualbox/private_key"
gitlab-runner restart
gitlab-runner status
```
