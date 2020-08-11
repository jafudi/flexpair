# Competitor Analysis

## Providers

- [AnyDesk](https://anydesk.com/de/features): AnyDesk uses a *proprietary video codec* "DeskRT" that is designed to allow users to experience higher-quality video and sound transmission while reducing the transmitted amount of data to the minimum. With its three megabyte total program size, AnyDesk is noted as an especially *lightweight application*. *No browser-access as of now*.
- [BigBlueButton](https://bigbluebutton.org/teachers/): BigBlueButton implements the core web conferencing features you would expect in a commercial system, but under an *open source* license. These core feature include *audio/video* sharing, *presentations* with extended *whiteboard* capabilities - such as a pointer, zooming and drawing - public and private *chat*, *breakout rooms*, *screen sharing*, *integrated VoIP using FreeSWITCH*, and support for presentation of PDF documents and Microsoft Office documents. BigBlueButton is a *pure HTML5 client*. It uses the browser's support for web real-time communications WebRTC to send/receive audio, video, and screen.
- [Jitsi](https://jitsi.org/user-faq/): It is an open source JavaScript WebRTC application and can be used for videoconferencing. One can share desktop and presentations and with just a link can invite new members for videoconference. It can be used by downloading the app or directly in a browser and it is compatible with any recent browser. Every user can use Jitsi.org servers or can download and install the server software on a Linux-based machine.
- [GoTo Meeting](https://www.gotomeeting.com/de-de/funktionen): GoToMeeting is designed to broadcast the desktop view of a host computer to a group of computers connected to the host through the Internet. Transmissions are protected with high-security encryption and optional passwords. By combining a web-hosted subscription service with software installed on the host computer, transmissions can be passed through highly restrictive firewalls.
- [MS Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/group-chat-software/): Microsoft Teams is a unified communication and collaboration platform that combines persistent workplace chat, video meetings, file storage (including collaboration on files), and application integration. The service integrates with the Office 365 subscription office productivity suite and features extensions that can integrate with non-Microsoft products. Microsoft Teams is a competitor to services such as Slack and is the evolution and upgrade path from Microsoft Skype for Business.
- [nomachine](https://www.nomachine.com/de/fernzugriff-f%C3%BCr-alle): NX technology, commonly known as NX, is a proprietary suite of products for desktop virtualization and application delivery for servers and client software, developed by the Luxemburg-based company NoMachine. NX—or NoMachine, as it is often referred to since the release of version 4—is platform-agnostic. It can be installed on Linux, Windows and Mac instances virtualised within popular hypervisors like Xen, KVM or VMware, and integrated with any virtual desktop infrastructure running in private or public clouds, such as Amazon EC2 or Rackspace.
- [TeamViewer](https://www.teamviewer.com/en/products/teamviewer/): TeamViewer is a proprietary software application for remote control, desktop sharing, online meetings, web conferencing and file transfer between computers. It is also possible to access a machine running TeamViewer with a web browser. While the main focus of the application is remote control of computers, collaboration and presentation features are included.
- [WebEx](https://www.webex.com/de/pricing/index.html): Cisco Webex is an American company that develops and sells web conferencing and videoconferencing applications. Cisco Webex has a time limit of 50 minutos (free service) and 24 hours (registered clients).
- [X2Go](https://wiki.x2go.org/doku.php/doc:newtox2go): X2Go is an open source remote desktop software for Linux that uses a modified NX 3 protocol. X2Go gives remote access to a Linux system's graphical user interface. It can also be used to access Windows systems through a proxy.
- [Zoom](https://zoom.us/de-de/meetings.html): It provides a video chatting service that allows up to 100 devices at once for free, with a 40-minute time restriction for free accounts having meetings of three or more participants. During the COVID-19 pandemic, Zoom has seen a major increase in usage for remote work, distance education, and online social relations. It is noted for its simple interface and usability, specifically for non-tech people. Features include one-on-one meetings, group video conferences, screen sharing, plugins, browser extensions, and the ability to record meetings and have them automatically transcribed. On some computers and operating systems, users are able to select a virtual background, which can be downloaded from different sites, to use as a backdrop behind themselves.

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

