# Currently deployable in 33 cities worldwide (and counting)

- Australia
  - Melbourne
  - Sydney
  - Canberra (soon with Azure)
- Bahrain
  - Manama
- Brazil
  - São Paulo
- Canada
  - Montreal
  - Toronto
    Quebec City (soon with Azure)
- China
  - Beijing
  - Hong Kong
  - Ningxiang
  - Chengdu (soon with Alibaba)
  - Hangzhou (soon with Alibaba)
  - Heyuan (soon with Alibaba)
  - Hohhot (soon with Alibaba)
  - Qingdao (soon with Alibaba)
  - Shanghai (soon with Alibaba or Azure)
  - Shenzhen (soon with Alibaba)
  - Zhangjiakou (soon with Alibaba)
- France
  - Marseille (soon with Azure)
  - Paris
- Germany
  - Berlin (soon with Azure)
  - Frankfurt
  - Magdeburg (soon with Azure)
- India
  - Chennai (soon with Azure)
  - Hyderabad
  - Mumbai
  - Pune (soon with Azure)
- Indonesia
  - Jakarta (soon with Alibaba)
- Ireland
  - Dublin
- Italy
  - Milan
- Japan
  - Osaka
  - Saitama (soon with Azure)
  - Tokyo
- Malaysia
  - Kuala Lumpur (soon with Alibaba)
- Netherlands
  - Amsterdam
  - Middenmeer (soon with Azure)
- Norway
  - Oslo (Azure)
  - Stavanger (soon with Azure)
- Saudi Arabia
  - Jeddah
- Singapore
- South Africa
  - Cape Town
  - Johannesburg (soon with Azure)
- South Korea
  - Busan (soon with Azure)
  - Chuncheon
  - Seoul
- Sweden
  - Stockholm
- Switzerland
  - Geneva (soon with Azure)
  - Zürich
- United Arab Emirates
  - Abu Dhabi (soon with Azure)
  - Dubai (soon with Azure or Alibaba)
- United Kingdom
  - Cardiff (soon with Azure)
  - London
- United States
  - Ashburn, Virginia
  - Austin, Texas (soon with Azure)
  - Boardman, Oregon
  - Cheyenne, Wyoming (soon with Azure)
  - Chicago, Illinois (soon with Azure)
  - Des Moines, Iowa (soon with Azure)
  - Hilliard, Ohio
  - Phoenix, Arizona
  - San Francisco, California
  - San Jose, California
  - Washington, D.C.
  - Quincy, WA (soon with Azure)
  - Richmond, Virginia (soon with Azure)
  - San Antonio, TX (soon with Azure)

# What are the main features?

Isomorphisms between
- Git branch
- Terraform workspace
- OCI compartment
- DNS zone

<table border="0">
 <tr>
    <td><b style="font-size:30px">Desktop node</b></td>
    <td><b style="font-size:30px">Gateway node</b></td>
 </tr>
 <tr>
   <td>
     <ul>
       <li>Ubuntu 20.04 LTS</li>
       <li>Light weight LXQt Desktop</li>
       <li>Participates as Mumble user</li>
       <li>Record conference audio</li>
       <li>Listen to music or podcasts together</li>
     </ul>
   </td>
   <td>
     <ul>
       <li>In-browser remote desktop using Apache Guacamole</li>
       <li>Mumble audio server backend within Docker</li>
       <li>In-browser high-quality audio conferencing</li>
       <li>Dockerized Dovecot IMAP Server</li>
     </ul>
   </td>
 </tr>
</table>

# Market Analysis and Unique Selling Point

[Microsoft Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/group-chat-software/) integrates Skype with Outlook and SharePoint. You can store files in the cloud and share your local desktop with other meeting participants, but there is no  virtual cloud desktop that everyone can access. Same appplies to their direct competitor Slack. Also, sharing the local desktop works rather lousy because it involves a video uplink on an asymmetric connection.

Existing virtual desktop solutions are all closed-source offers to the business world. The top players in this market are:

- [Nutanix](https://www.nutanix.com/de/products/frame) testen!
- [Itopia](https://itopia.com/) testen!
- [Mikogo Cloud Desktop](https://www.mikogo.com/cloud-desktop/) testen!
- [V2 Cloud](https://v2cloud.com) testen!
- [Windows Desktop on Azure](https://azure.microsoft.com/en-us/services/virtual-desktop/)
- [Amazon WorkSpaces](https://aws.amazon.com/de/workspaces/?workspaces-blogs.sort-by=item.additionalFields.createdDate&workspaces-blogs.sort-order=desc)
- [Oracle Secure Global Desktops](https://www.oracle.com/ae/secure-global-desktop/)

Some of these solutions might include collaboration and conferencing components (research yet to be completed), but it is certainly not their focus.

We also do not intend to compete with commercial video conferencing solutions like Zoom or WebEx for two reasons. First, they are too big and established. Second, there is already [Zoom fatigue](https://www.ardaudiothek.de/ab-21/gaehn-warum-uns-videocalls-so-muede-machen/76335364) and absurd workarounds like background substitution requiring the application of energy consuming deep learning models.

Instead, we focus on:
- unsurpassed audio quality and low bandwidth usage
- zero-install on client side
- simpler to set up than other more video focussed open source servers like Jitsi or BigBlueButton
- works from free tier virtual machines upwards
- affordable for small clubs, schools and NGOs
- data privacy through separate VM and strong encryption
- no metadata collection of communications
- choice of server location and agnostic of cloud provider
- so you can combine free VM from e.g. Amazon and Google Cloud
- custom domain and customization of provisioned software
- automated and reproducable provisioning of the environment
- include tools for DevOps users and software testing

Still look at:
- Studio Code Live Share
- Heroku
- https://jamm.app/en/

https://gerrymcgovern.com/the-hidden-pollution-cost-of-online-meetings/

https://ourworldindata.org/internet
https://ourworldindata.org/mental-health

Data privacy, intellectual property and saving the climate all at the same time :-)


# Potential Testers / Early Adopters

- Papa um uns Unterlagen für Wipperfliess zu zeigen
- Lea für Stationsversammlung mit OpenSlides
- Ying zum Demonstrieren Ihrer eigenen App
- Werner zum Qt-Programmieren
- Selbsthilfebüro für Karaoke-Abend
- Achim bei der Bahn für Mob Programming
- Björn für CdE-Orga

# Minimal Requirements

- 2 VMs with 1 GB of RAM each (available for free from e.g. [Oracle Cloud](https://www.oracle.com/cloud/))
- not necessarily with the same cloud provider (cloud-agnostic)
- 100 kbit/s uplink at the user's location
- Server must have the following open ports: 22 (SSH), 443 (SSL)
- Nice to have open server ports: 64738 (Mumble), 25 (SMTP)

# Unique Selling Point(s)

- receive email on project specific email account
- PaaS between Saas and IaaS
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
- one-click installation on free tier cloud infrastructure
- communication between servers and clients always encrypted
- stable, yet resource-friendly conferencing even at low bandwidth
- low latency, high quality
- now video, at least no upload
- idea exchange reduced to the max
- exactly what we need during Corona
- and did we mention: it's free
- mumble.com charges 7.50$ a month for up to 15 users (without desktop!!)
- [Mumble](https://www.mumble.info) and [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) both over HTTPS
- [SSH tunnel](https://www.ssh.com/ssh/tunneling/) secured with [ed25519 encryption](http://ed25519.cr.yp.to)
- fast network connection in the cloud
- usable with standard set of open ports (22 SSH, 443 HTTPS)
- access (multiple) desktops via one central gateway, no need to remember IPs
- [nginx](https://docs.nginx.com/nginx/admin-guide/web-server/) and murmur share SSL certificate form [LetsEncrypt](https://letsencrypt.org)
- Prevention of full RAM and swapping
- some more cool arcade games and selection of games for kids
- lightweight [LXQt desktop](https://lxqt.github.io) with beautiful [ePapirus icons](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) and breeze theme
- [gPodder](https://gpodder.github.io) podcatcher connected with [VLC](https://www.videolan.org/vlc/index.html) media player
- list of my favorite podcasts in OPML format
- desktop takes part in Mumble conference, ability to record
- [Opus](https://opus-codec.org) audio codec
- Automatic [Trojita](http://trojita.flaska.net) email client configuration
- separate VMs for desktop and gateway, both deployed in parallel
- basic architecture diagram in structurizr according to the [C4 model](https://c4model.com)
- [Openbox](https://en.wikipedia.org/wiki/Openbox) window manager
- rock-solid [x11vnc](http://www.karlrunge.com/x11vnc/) server
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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| acme | ~> 1.5.0 |
| aws | ~> 3.18 |
| dns | ~> 2.2.0 |
| null | ~> 3.0.0 |
| oci | ~> 3.95.0 |
| random | ~> 2.3.0 |
| template | ~> 2.2.0 |
| time | ~> 0.6.0 |
| tls | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| dns | ~> 2.2.0 |
| null | ~> 3.0.0 |
| time | ~> 0.6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| TFC\_CONFIGURATION\_VERSION\_GIT\_BRANCH | This is the name of the branch that the associated Terraform configuration version was ingressed from (e.g. master). | `string` | n/a | yes |
| TFC\_CONFIGURATION\_VERSION\_GIT\_COMMIT\_SHA | This is the full commit hash of the commit that the associated Terraform configuration version was ingressed from (e.g. abcd1234...). | `string` | n/a | yes |
| TFC\_RUN\_ID | This is a unique identifier for this run (e.g. run-CKuwsxMGgMd4W7Ui). | `string` | n/a | yes |
| TFC\_WORKSPACE\_NAME | This is the name of the workspace used in this run, e.g. prod-load-balancers. | `string` | n/a | yes |
| aws\_access\_key | Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials | `string` | n/a | yes |
| aws\_region | Seems to determines the region of all created resources. | `string` | `"eu-central-1"` | no |
| aws\_secret\_key | Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials | `string` | n/a | yes |
| locale | n/a | `string` | `"de_DE.UTF-8"` | no |
| oci\_fingerprint | Fingerprint of the public key | `string` | `"9c:d0:a4:27:86:77:0e:0c:49:5a:8c:39:4a:a0:c3:ce"` | no |
| oci\_free\_tier\_avail | n/a | `number` | `2` | no |
| oci\_passphrase | Passphrase used for the key, if it is encrypted. Highly sensitive, as credit card could be charged | `string` | n/a | yes |
| oci\_private\_key | The contents of the private key file. Highly sensitive, as credit card could be charged. | `string` | n/a | yes |
| oci\_region | An Oracle Cloud Infrastructure region. Must be equal to the home region of the tenancy. | `string` | `"eu-frankfurt-1"` | no |
| oci\_tenancy\_ocid | Oracle Cloud ID (OCID) of the tenancy | `string` | `"ocid1.tenancy.oc1..aaaaaaaas3oie74wurpodkrygjpztwfscowu3rx42hadgheqrcmesnefllqa"` | no |
| oci\_user\_ocid | The user's Oracle Cloud ID (OCID) | `string` | `"ocid1.user.oc1..aaaaaaaaqfmvke4guehv3ejzc6p2nm4p7gki3o6csth2cqznv62zco76h6aa"` | no |
| registered\_domain | A registered domain pointing to rfc2136\_name\_server. | `string` | `"jafudi.de"` | no |
| rfc2136\_key\_name | The name of the TSIG key used to sign the DNS update messages | `string` | `"tsig-164066.dynv6.com."` | no |
| rfc2136\_key\_secret | A Base64-encoded string containing the shared secret to be used for TSIG | `string` | `"7I57AtxCp7PHfAfWsV9TviS+B3glddd9PGoBMo1bYBSicoKM3BdaQL9qnZBX7uy6Vi8r+46/HmOrMq767RRTPA=="` | no |
| rfc2136\_name\_server | The IPv4 address or URL of the DNS server to send updates to | `string` | `"ns1.dynv6.com"` | no |
| rfc2136\_tsig\_algorithm | When using TSIG authentication, the algorithm to use for HMAC | `string` | `"hmac-sha512"` | no |
| timezone | The name of the common system time zone applied to both VMs | `string` | `"Europe/Berlin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_via\_browser | n/a |
| access\_via\_mumble | n/a |
| aws\_base\_image | n/a |
| desktop\_config\_size | n/a |
| email\_adress | n/a |
| gateway\_config\_size | n/a |
| oci\_base\_image | n/a |
| private\_key | n/a |
| ssh\_into\_desktop\_1 | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

