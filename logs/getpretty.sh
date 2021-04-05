#!/bin/bash -eux

curl -s "$1" | sed -E -f sedscript > "log.csv"
