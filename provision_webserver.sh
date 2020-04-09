#!/usr/bin/env bash

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apache2
if ! [ -L /var/www ]; then
    rm -rf /var/www
    ln -fs /vagrant /var/www
fi

# This is a necessary workaround in order to neutralize a bug
# in VirtualBox shared folders, according to the Vagrant docs
# https://www.vagrantup.com/docs/synced-folders/virtualbox.html#caveats
echo -e "EnableSendfile Off" >> /etc/apache2/apache2.conf

apt-get install firefox
