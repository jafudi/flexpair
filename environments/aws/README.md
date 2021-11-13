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
| random | ~> 3.1.0 |
| template | ~> 2.2.0 |
| tfe | 0.25.3 |
| time | ~> 0.7.0 |
| tls | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| dnsimple | 0.6.0 |
| local | ~> 2.1.0 |
| null | ~> 3.1.0 |
| random | ~> 3.1.0 |
| tfe | 0.25.3 |
| time | ~> 0.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| amazon_infrastructure | app.terraform.io/jafudi/commons/aws | 1.0.0 |
| credentials_generator | ../../modules/terraform-tls-credentials |  |
| desktop_installer | git::ssh://git@gitlab.com/jafudi-group/terraform-cloudinit-satellite.git?ref=master |  |
| desktop_machine_1 | app.terraform.io/jafudi/desktop/aws | 1.2.0 |
| gateway_installer | git::ssh://git@gitlab.com/Jafudi/terraform-cloudinit-station.git?ref=master |  |
| gateway_machine | app.terraform.io/jafudi/gateway/aws | 1.1.0 |

## Resources

| Name |
|------|
| [dnsimple_record](https://registry.terraform.io/providers/dnsimple/dnsimple/0.6.0/docs/resources/record) |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |
| [tfe_oauth_client](https://registry.terraform.io/providers/hashicorp/tfe/0.25.3/docs/resources/oauth_client) |
| [tfe_run_trigger](https://registry.terraform.io/providers/hashicorp/tfe/0.25.3/docs/resources/run_trigger) |
| [tfe_variable](https://registry.terraform.io/providers/hashicorp/tfe/0.25.3/docs/resources/variable) |
| [tfe_workspace](https://registry.terraform.io/providers/hashicorp/tfe/0.25.3/docs/data-sources/workspace) |
| [tfe_workspace](https://registry.terraform.io/providers/hashicorp/tfe/0.25.3/docs/resources/workspace) |
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
| github\_personal\_access\_token | n/a | `string` | n/a | yes |
| gitlab\_runner\_token | n/a | `string` | n/a | yes |
| locale | n/a | `string` | `"de_DE.UTF-8"` | no |
| registered\_domain | A registered domain pointing to rfc2136\_name\_server. | `string` | `"pairpac.com"` | no |
| tfc\_api\_token | The user token for authenticating with Terraform Cloud | `string` | n/a | yes |
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
| gateway\_ip | n/a |
| gateway\_username | UNIX username used for the gateway |
| guacamole\_credentials | Credentials necessary to gain admin access to Guacamole |
| private\_key | Set back to sensitive!!! |
| ssh\_into\_desktop\_1 | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
