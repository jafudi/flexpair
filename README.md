# Minimal Requirements

- 2 VMs with 1 GB of RAM each (available for free)
- not necessarily with the same cloud provider
- a free user account at [Dynu Dynamic DNS](https://www.dynu.com)
- what is the minimum bandwidth 1. between nodes 2. at the user's location ?

# Key features

- stable, yet resource-friendly conferencing even at low bandwidth
- low latency, high quality
- now video, at least no upload
- idea exchange reduced to the max
- exactly what we need during Corona
- and did we mention: it's free
- Mumble and VNS both over HTTPS
- Automatically register DDNS records
- Mount home folder on gateway as folder on desktop
- Mumble web works with Chrome, not with Firefox or Safari so far
- Add support for openslides
- gateway and desktop traffic stats available directly in the browser
- SSH tunnel secured with ed25519 encryption
- fast network connection in the cloud
- usable with standard set of open ports (22 SSH, 80 HTTP, 443 HTTPS)
- access (multiple) desktops via one central gateway, no need to remember IPs
- nginx and murmur share SSL certificate form LetsEncrypt
- Prevention of full RAM and swapping
- some more cool arcade games and selection of games for kids
- lightweight LXQt desktop with beautiful ePapirus icons and breeze theme
- gPodder podcatcher connected with VLC media player
- list of my favorite podcasts in OPML format
- desktop takes part in Mumble conference, ability to record
- OPUS audio codec
- meteo-qt weather app
- Automatic email client configuration
- separate VMs for desktop and gateway, both deployed in parallel
- basic C4 architecture diagram in structurizr
- lightdm login manager
- openbox window manager
- rock-solid x11vnc server
- Combine letsencrypt ssl settings with guacamole proxy_pass
- chose Oracle Cloud mainly because two free VMs
- using docker-compose
- VM will register itself as Gitlab
- Automatically add tags describing the host when registering gitlab runner
- Based on ubuntu-minimal-2004-lts Focal Fossa

# Use cases

## gPodder + VLC + Mumble use cases
- Corona Karaoke including 3D audio, bring-your-own-alcohol if you like
- Listening to and discussing podcasts together
- Listening to Audio porn together

## Web browser use cases
- Collaborative planning of e.g. travel over distance
- Doing e-learning together

## Docker + GitLab Runner use cases
- Software demos and user testing
- Mob programming
- Digitale Vereinssitzung, Konkurrenzsoftware OpenSlides

## Other use cases
- Presenting and discussing slides
- Virtual conference table with positional audio
- Project management files and conferencing in one place
- Secretary work, virtual personal assistant

# Todos and planned features

- Migrate from Packer to Terraform Cloud
- Crowdfunding campaign

