#!/bin/bash

supported_clouds="aws oracle azure"

script_abspath=$(realpath "$0")
environ_folder=$(dirname "${script_abspath}")
for gateway in ${supported_clouds}
do
    for desktop in ${supported_clouds} hybrid
    do
        if [ "$desktop" != "$gateway" ]
        then
            sub_folder="${environ_folder}/$gateway-$desktop"
        else
            sub_folder="${environ_folder}/$gateway"
        fi
        mkdir -p "${sub_folder}"
        cp -a "${environ_folder}/_template/." "${sub_folder}/"
    done
done
