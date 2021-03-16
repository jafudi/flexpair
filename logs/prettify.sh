#!/bin/bash -eux

sed -f sedscript "$1" > "$1.csv"
