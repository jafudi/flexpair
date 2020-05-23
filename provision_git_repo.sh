#!/usr/bin/env bash

cd /var/tmp
rm -rf traction
git clone --depth 1 https://github.com/jafudi/traction.git --branch master
chmod 777 -R traction
