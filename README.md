# Getting Started

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
- [Gitlab Runner](https://docs.gitlab.com/runner/install/)

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
    --description="staging-vm" \
    --tag-list="virtualbox" \
    --virtualbox-base-name="ubuntu_bionic_vbox" \
    --virtualbox-disable-snapshots="false" \
    --ssh-user="vagrant" \
    --ssh-password="vagrant" \
    --ssh-identity-file="$PWD/.vagrant/machines/default/virtualbox/private_key"
gitlab-runner restart
gitlab-runner status
```
