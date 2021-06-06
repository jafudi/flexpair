## Public cloud architecture

### Software systems
- [terraform-cloudinit-desktop](./modules/terraform-cloudinit-desktop/README.md)
- [terraform-cloudinit-gateway](./modules/terraform-cloudinit-gateway/README.md)
- [terraform-tls-credentials](./modules/terraform-tls-credentials/README.md)

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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
