## Identity and access management (IAM)

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
| guacamole | 1.2.1 |

## Providers

| Name | Version |
|------|---------|
| guacamole | 1.2.1 |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [guacamole_connection_ssh](https://registry.terraform.io/providers/techBeck03/guacamole/1.2.1/docs/resources/connection_ssh) |
| [guacamole_connection_vnc](https://registry.terraform.io/providers/techBeck03/guacamole/1.2.1/docs/resources/connection_vnc) |
| [guacamole_user_group](https://registry.terraform.io/providers/techBeck03/guacamole/1.2.1/docs/resources/user_group) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| organization\_name | n/a | `string` | n/a | yes |
| parent\_workspace\_name | n/a | `string` | n/a | yes |
| ssh\_color\_scheme | n/a | `string` | `"green-black"` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
