# Competitor Analysis

https://www.ardaudiothek.de/ab-21/gaehn-warum-uns-videocalls-so-muede-machen/76335364

# Virtual Cloud Desktop as a Service

- [Windows Desktop on Azure](https://azure.microsoft.com/en-us/services/virtual-desktop/)
- [itopia, Citrix, VMware and Nutanix Frame on Google Cloud](https://cloud.google.com/solutions/virtual-desktops)
- [OVH Virtual Cloud Desktop](https://www.ovh.com/asia/cloud/cloud-desktop/)
- [Amazon WorkSpaces](https://aws.amazon.com/de/workspaces/?workspaces-blogs.sort-by=item.additionalFields.createdDate&workspaces-blogs.sort-order=desc)
- [Mikogo Cloud Desktop](https://www.mikogo.com/cloud-desktop/)
- [V2 Cloud](https://v2cloud.com)
- [Cloud Geeni](https://cloudgeeni.co.uk/features/)

- [MS Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/group-chat-software/) is a **competitor to services such as Slack** and is the evolution **and upgrade path from Microsoft Skype** for Business.
- [TeamViewer](https://www.teamviewer.com/en/products/teamviewer/): **Free for private use**, TeamViewer is a **proprietary software application for remote control, desktop sharing, online meetings, web conferencing and file transfer between computers**. It is also possible to access a machine running TeamViewer with a web browser. **While the main focus of the application is remote control of computers, collaboration and presentation features are included**.
- [Zoom](https://zoom.us/de-de/meetings.html): It provides a video chatting service that allows up to 100 devices at once **for free, with a 40-minute time restriction** for free accounts having meetings of three or more participants. During the COVID-19 pandemic, Zoom has seen a major increase in usage for remote work, distance education, and online social relations. It is noted for its **simple interface** and usability, specifically for non-tech people. Features include one-on-one meetings, **group video conferences, screen sharing, plugins, browser extensions, and the ability to record meetings and have them automatically transcribed**. On some computers and operating systems, users are able to select a **virtual background**, which can be downloaded from different sites, to use as a backdrop behind themselves.
- [BigBlueButton](https://bigbluebutton.org/teachers/) is like Jitsi but **tailored specifically to education**
- [Jitsi](https://jitsi.org/user-faq/) is **open-source video conferencing** where you can also share your local desktop
- [X2Go](https://wiki.x2go.org/doku.php/doc:newtox2go) is **comparable to Apache Guacamole** and is also open source

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

