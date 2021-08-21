## Public cloud architecture

### Software systems
- [terraform-cloudinit-desktop](./modules/terraform-cloudinit-desktop/README.md)
- [terraform-cloudinit-gateway](./modules/terraform-cloudinit-gateway/README.md)
- [terraform-tls-credentials](./modules/terraform-tls-credentials/README.md)

### Deploy mechanism
- Clone source code from GitHub to Terraform Cloud workspace
- Input credentials and other variables
- Plan and execute deployment

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
| acme | ~> 2.4.0 |
| aws | ~> 3.18 |
| dnsimple | 0.6.0 |
| local | ~> 2.1.0 |
| null | ~> 3.1.0 |
| oci | ~> 3.95.0 |
| random | ~> 3.1.0 |
| template | ~> 2.2.0 |
| time | ~> 0.7.0 |
| tls | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| dnsimple | 0.6.0 |
| local | ~> 2.1.0 |
| null | ~> 3.1.0 |
| random | ~> 3.1.0 |
| time | ~> 0.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| amazon_infrastructure | app.terraform.io/jafudi/commons/aws | 1.0.0 |
| credentials_generator | ../modules/terraform-tls-credentials |  |
| desktop_installer | git::ssh://git@gitlab.com/jafudi-group/terraform-cloudinit-satellite.git?ref=master |  |
| desktop_machine_1 | app.terraform.io/jafudi/desktop/oci | 1.0.1 |
| gateway_installer | git::ssh://git@gitlab.com/Jafudi/terraform-cloudinit-station.git?ref=master |  |
| gateway_machine | app.terraform.io/jafudi/gateway/aws | 1.0.8 |
| oracle_infrastructure | app.terraform.io/jafudi/commons/oci | 1.1.0 |

## Resources

| Name |
|------|
| [dnsimple_record](https://registry.terraform.io/providers/dnsimple/dnsimple/0.6.0/docs/resources/record) |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |
| [time_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| TFC\_CONFIGURATION\_VERSION\_GIT\_BRANCH | This is the name of the branch that the associated Terraform configuration version was ingressed from (e.g. master). | `string` | n/a | yes |
| TFC\_CONFIGURATION\_VERSION\_GIT\_COMMIT\_SHA | This is the full commit hash of the commit that the associated Terraform configuration version was ingressed from (e.g. abcd1234...). | `string` | n/a | yes |
| TFC\_RUN\_ID | This is a unique identifier for this run (e.g. run-CKuwsxMGgMd4W7Ui). | `string` | n/a | yes |
| TFC\_WORKSPACE\_SLUG | String indicating organization and workspace name. | `string` | n/a | yes |
| aws\_access\_key | Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials | `string` | n/a | yes |
| aws\_region | Seems to determines the region of all created resources. | `string` | `"eu-central-1"` | no |
| aws\_secret\_key | Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials | `string` | n/a | yes |
| dnsimple\_account\_id | n/a | `number` | n/a | yes |
| dnsimple\_account\_token | n/a | `string` | n/a | yes |
| locale | n/a | `string` | `"de_DE.UTF-8"` | no |
| oci\_fingerprint | Fingerprint of the public key | `string` | `"9c:d0:a4:27:86:77:0e:0c:49:5a:8c:39:4a:a0:c3:ce"` | no |
| oci\_free\_tier\_avail | n/a | `number` | `2` | no |
| oci\_passphrase | Passphrase used for the key, if it is encrypted. Highly sensitive, as credit card could be charged | `string` | n/a | yes |
| oci\_private\_key | The contents of the private key file. Highly sensitive, as credit card could be charged. | `string` | n/a | yes |
| oci\_region | An Oracle Cloud Infrastructure region. Must be equal to the home region of the tenancy. | `string` | `"eu-frankfurt-1"` | no |
| oci\_tenancy\_ocid | Oracle Cloud ID (OCID) of the tenancy | `string` | `"ocid1.tenancy.oc1..aaaaaaaas3oie74wurpodkrygjpztwfscowu3rx42hadgheqrcmesnefllqa"` | no |
| oci\_user\_ocid | The user's Oracle Cloud ID (OCID) | `string` | `"ocid1.user.oc1..aaaaaaaaqfmvke4guehv3ejzc6p2nm4p7gki3o6csth2cqznv62zco76h6aa"` | no |
| registered\_domain | A registered domain pointing to rfc2136\_name\_server. | `string` | `"pairpac.com"` | no |
| timezone | The name of the common system time zone applied to both VMs | `string` | `"Europe/Berlin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_via\_browser | n/a |
| access\_via\_mumble | n/a |
| desktop\_base\_image | n/a |
| desktop\_config\_size | n/a |
| first\_vnc\_credentials | Credentials for the first desktop's VNC connection |
| gateway\_base\_image | n/a |
| gateway\_config\_size | n/a |
| gateway\_username | UNIX username used for the gateway |
| guacamole\_credentials | Credentials necessary to gain admin access to Guacamole |
| private\_key | n/a |
| ssh\_into\_desktop\_1 | n/a |
| ssh\_into\_gateway | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
