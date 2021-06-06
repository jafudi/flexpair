#!/bin/bash

supported_clouds="aws oracle azure"

for gateway in ${supported_clouds}
do
    for desktop in ${supported_clouds} hybrid
    do
        if [ "$desktop" != "$gateway" ]
        then
            folder_name="$gateway-$desktop"
        else
            folder_name="$gateway"
        fi
        mkdir -p "${folder_name}"
        cp -a _template/. "${folder_name}/"
    done
done
