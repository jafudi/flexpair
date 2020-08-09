# Competitor Analysis

## Providers

- [AnyDesk](https://anydesk.com/de/features)
- [BigBlueButton](https://bigbluebutton.org/teachers/)
- [Jitsi](https://jitsi.org/user-faq/)
- [GoTo Meeting](https://www.gotomeeting.com/de-de/funktionen)
- [MS Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/group-chat-software/)
- [nomachine](https://www.nomachine.com/de/fernzugriff-f%C3%BCr-alle)
- [TeamViewer](https://www.teamviewer.com/en/products/teamviewer/)
- [WebEx](https://www.webex.com/de/pricing/index.html)
- [X2Go](https://wiki.x2go.org/doku.php/doc:newtox2go)
- [Zoom](https://zoom.us/de-de/meetings.html)

## Applicable Criteria

- Encryption
- File transfer
- Video
- Chat tool
- Audio
- Remote assistance
- NAT passthrough
- Session recording
- Whiteboard
- Browser-based access
- Session persistence

# Potential Testers / Early Adopters

- Papa für seine Partei mit OpenSlides
- Papa um uns Unterlagen für Wipperfliess zu zeigen
- Mama für Sippentreffen
- Lea für Stationsversammlung mit OpenSlides
- Yayoi für Hoshuko
- Ying zum Demonstrieren Ihrer eigenen App
- Werner zum Qt-Programmieren
- Selbsthilfebüro für Karaoke-Abend
- Achim bei der Bahn für Mob Programming
- Björn für CdE-Orga

# Minimal Requirements

- 2 VMs with 1 GB of RAM each (available for free from e.g. [Oracle Cloud](https://www.oracle.com/cloud/))
- not necessarily with the same cloud provider (cloud-agnostic)
- a free user account at [Dynu Dynamic DNS](https://www.dynu.com)
- what is the minimum bandwidth 1. between nodes 2. at the user's location ?

# Unique Selling Point(s)

- desktop sharing done right
- persistent storage of your docs
- everyone is able to edit without need for switching controls
- hear each other crystal clear, listen to podcasts and more
- until all is said: no time limitations whatsoever
- no additional software: use your favorite web browser
- keep your private space private: no webcams involved

# Technical details
- SSH tunnnel between desktop and gateway across clouds and borders
- For example: Gateway on Azure within the US, while desktop on Alibaba in China
- one-click install on free tier cloud infrastructure
- communication between servers and clients always encrypted
- stable, yet resource-friendly conferencing even at low bandwidth
- low latency, high quality
- now video, at least no upload
- idea exchange reduced to the max
- exactly what we need during Corona
- and did we mention: it's free
- mumble.com charges 7.50$ a month for up to 15 users (without desktop!!)
- [Mumble](https://www.mumble.info) and [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) both over HTTPS
- Automatically register DDNS records
- Mount home folder on gateway as folder on desktop
- Mumble web works with Chrome, not with Firefox or Safari so far
- Add support for [OpenSlides](https://openslides.com/en)
- gateway and desktop traffic stats available directly in the browser
- [SSH tunnel](https://www.ssh.com/ssh/tunneling/) secured with [ed25519 encryption](http://ed25519.cr.yp.to)
- fast network connection in the cloud
- usable with standard set of open ports (22 SSH, 80 HTTP, 443 HTTPS)
- access (multiple) desktops via one central gateway, no need to remember IPs
- [nginx](https://docs.nginx.com/nginx/admin-guide/web-server/) and murmur share SSL certificate form [LetsEncrypt](https://letsencrypt.org)
- Prevention of full RAM and swapping
- some more cool arcade games and selection of games for kids
- lightweight [LXQt desktop](https://lxqt.github.io) with beautiful [ePapirus icons](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) and breeze theme
- [gPodder](https://gpodder.github.io) podcatcher connected with [VLC](https://www.videolan.org/vlc/index.html) media player
- list of my favorite podcasts in OPML format
- desktop takes part in Mumble conference, ability to record
- [Opus](https://opus-codec.org) audio codec
- meteo-qt weather app
- Automatic [Trojita](http://trojita.flaska.net) email client configuration
- separate VMs for desktop and gateway, both deployed in parallel
- basic architecture diagram in structurizr according to the [C4 model](https://c4model.com)
- lightdm login manager
- [Openbox](https://en.wikipedia.org/wiki/Openbox) window manager
- rock-solid [x11vnc](http://www.karlrunge.com/x11vnc/) server
- Combine letsencrypt ssl settings with [Apache Guacamole](https://guacamole.apache.org) proxy_pass
- chose Oracle Cloud mainly because two free VMs
- using [Docker Compose](https://docs.docker.com/compose/)
- VM will register itself as Gitlab
- Automatically add tags describing the host when registering gitlab runner
- Based on [Ubuntu Focal Fossa](https://wiki.ubuntu.com/FocalFossa/ReleaseNotes) which has long term support until April 2025

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

