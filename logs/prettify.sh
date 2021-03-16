#!/bin/bash -eux

sed -E -f sedscript "$1" > "$1.csv"
