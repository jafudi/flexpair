#!/bin/sh -eux

# Allow connections to non-standard localhost ports which are necessary for the 'nginx' and 'guac' containers
# which do have their own IP addresses within a virtualized Docker network while still running on the same VM
iptables -I INPUT 1 -p tcp --dport "${VNC_PORT}" -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac container to VNC
iptables -I INPUT 2 -p tcp --dport 4713 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac container to PulseAudio
iptables -I INPUT 3 -p tcp --dport 2222 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # guac via SSH to desktop
iptables -I INPUT 4 -p tcp --dport 667 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # nginx to DarkStat on gateway
iptables -I INPUT 5 -p tcp --dport 6667 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT # nginx to DarkStat on desktop
netfilter-persistent save




