#!/bin/bash -eux

sed 's/\x1b\[[0-9]m//g'

sed 's/ \(remote-exec\)//g'

sed 's/module.*instance//g'

Delete lines that contain 'Reading database'
