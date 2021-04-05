# PairPac enables voice-first hands-on co-creation anywhere

PairPac stands for "Pair programming Platform as Code". This is the use case we started from. Then we quickly realized that you can use PairPac in so many more situations. PairPac is especially suitable for you and your team, if you are looking for a virtual creative space that is developed with continuous emphasis on the following design principles:

- Interactive, not Big Brother
- Flexible usage, not volatile
- Persistent, not locked-in by contract
- Open standards, not insecure
- Modular, not a workaround
- Scalable, not off-the-shelf

and last but not least achieves:
- less consumption (RAM, bandwidth) yet more reliability

The least thing we want is to waste your precious time. Therefore, please do not read any further

- if you are keen on inviting every work contact into your living room, you are probably better off using [Zoom](https://zoom.us), [WebEx](https://www.webex.com/de/index.html), [Jitsi](https://jitsi.org) etc.
- if you really need to give someone remote access to your local machine, please consider using [TeamViewer](https://www.teamviewer.com/en/) or comparable established solutions

In any other case, we would love to have you as our valued customer.

## Selected use cases

### Change society towards fair intellectual property and fair healthcare

- ☁️ Brain storming and technology brokering for everyone 🧠💡♻
- 🪁 Patient-centered healthcare for everyone 🏥👩‍⚕️️🩺🤕🧘📧👩🏾‍🔬‍🧫🔬
- Keep track of the whole interaction history in one place
- Maintain data privacy by locking out data collectors
- No additional software: use your favorite web browser without installation

### Enable effective and human-friendly remote work

- 🏄 Seamless task delegation to remote assistants 👩🏻‍💼👉🏻✅👂🏼‍🧞‍♂️
- 🏄 Interactive remote team programming  🌎🏝👨‍💻♾👩‍💻☕🏠
- Unified tool for synchronous and asynchronous collaboration
- Fully reproducible environment through infrastructure-as-code with [Terraform](https://www.terraform.io)
- Combine (free) resources across all major cloud providers
- Keep your private space private: no webcams involved


### Support mutual understanding through culture and leisure

- 🐟 Professional podcast production across the globe 👳🏿‍♂️🎙🎛⟷🎙👨🏻‍🦰🎧
- 🐚 Virtual karaoke parties 🎉🕺🎶⟷🎤🥳🎼
- High audio quality and low latency at moderate bandwidth requirements using the [Opus Codec](https://opus-codec.org)
- Until all is said: no time limitations whatsoever
- Receive email from your followers on a dedicated email account

Annotation of user goal levels similar to [Cockburn style](https://en.wikipedia.org/wiki/Use_case#Templates)

1. TODO: Assign contacts as well as competitor products to use cases
2. TODO: Ask people on SurveyCircle to come up with their own emojis for how they understand the description

## What is PairPac at its core, technically?

PairPac stands for Pair Programming Platform as Code. More technically, it is a collection of Terraform modules and cloud-init scripts for deploying a shared cloud desktop (Ubuntu 20.04 LTS) with high quality audio conferencing and self-hosted email inbox to an arbitrary public cloud account. Free tier resources are sufficient and multicloud is actively supported.

## Some screenshots

![Some screenshots](./documentation/ezgif.com-gif-maker.gif)


## Architecture

### Software systems
- [terraform-cloudinit-desktop](./modules/terraform-cloudinit-desktop/README.md)
- [terraform-cloudinit-gateway](./modules/terraform-cloudinit-gateway/README.md)
- [terraform-tls-credentials](./modules/terraform-tls-credentials/README.md) (refactoring needed)

### Deploy mechanism
- Clone source code from GitHub to Terraform Cloud workspace
- Input credentials and other variables
- Plan and execute deploy

### Deploy environments / nodes

- User computer or mobile device
  - Mozilla Firefox
  - Google Chrome
  - Apple Safari
  - Microsoft Edge

- Account with DynV6 DNS provider
  - TLS certificate
  - DNS A record

- Amazon AWS cloud account
  - [terraform-aws-commons](https://github.com/jafudi/terraform-aws-commons)
  - [terraform-aws-desktop](https://github.com/jafudi/terraform-aws-desktop)
  - [terraform-aws-gateway](https://github.com/jafudi/terraform-aws-gateway)
- Oracle OCI cloud cloud account
  - [terraform-oci-commons](https://github.com/jafudi/terraform-oci-commons)
  - [terraform-oci-desktop](https://github.com/jafudi/terraform-oci-desktop)
  - [terraform-oci-gateway](https://github.com/jafudi/terraform-oci-gateway)


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

## Modules

| Name | Source | Version |
|------|--------|---------|
| amazon_infrastructure | app.terraform.io/jafudi/commons/aws | 1.0.0 |
| credentials_generator | ./modules/terraform-tls-credentials |  |
| desktop_installer | app.terraform.io/jafudi/satellite/cloudinit | 1.3.12 |
| desktop_machine_1 | app.terraform.io/jafudi/desktop/oci | 1.0.0 |
| gateway_installer | app.terraform.io/jafudi/station/cloudinit | 1.4.3 |
| gateway_machine | app.terraform.io/jafudi/gateway/aws | 1.0.2 |
| oracle_infrastructure | app.terraform.io/jafudi/commons/oci | 1.0.0 |

## Resources

| Name |
|------|
| [dns_a_record_set](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/resources/a_record_set) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [time_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) |

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
| registered\_domain | A registered domain pointing to rfc2136\_name\_server. | `string` | `"pairpac.com"` | no |
| rfc2136\_key\_name | The name of the TSIG key used to sign the DNS update messages | `string` | `"tsig-224951.dynv6.com."` | no |
| rfc2136\_key\_secret | A Base64-encoded string containing the shared secret to be used for TSIG | `string` | `"wg46X5+cZJdF7rwInheeqPv/NK56d0Oj+m7LCbuG0186tgxlvgzWR3qoynQAbpG68272pT5HutAzbbqI+IxWgA=="` | no |
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
| ssh\_into\_gateway | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Direct and indirect competitors

### Virtual Cloud Desktops
- [Nutanix](https://www.nutanix.com/de/products/frame) testen!
- [Itopia](https://itopia.com/) testen!
- [Mikogo Cloud Desktop](https://www.mikogo.com/cloud-desktop/) testen!
- [V2 Cloud](https://v2cloud.com) testen!
- [Windows Desktop on Azure](https://azure.microsoft.com/en-us/services/virtual-desktop/)
- [Amazon WorkSpaces](https://aws.amazon.com/de/workspaces/?workspaces-blogs.sort-by=item.additionalFields.createdDate&workspaces-blogs.sort-order=desc)
- [Oracle Secure Global Desktops](https://www.oracle.com/ae/secure-global-desktop/)


### Collaboration Tools
- [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/group-chat-software/)
- [BigBlueButton](https://bigbluebutton.org)
- [Studio Code Live Share](https://visualstudio.microsoft.com/de/services/live-share/) and [others](https://raygun.com/blog/remote-pair-programming/)
- [Gitpod](https://www.gitpod.io)
