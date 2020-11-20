module "certified_hostname" {
  source                 = "./modules/certified_dns_hostname"
  registered_domain      = var.registered_domain
  subdomain_proposition  = "${var.TFC_CONFIGURATION_VERSION_GIT_BRANCH}-branch-${var.TFC_WORKSPACE_NAME}"
  rfc2136_name_server    = var.rfc2136_name_server
  rfc2136_key_name       = var.rfc2136_key_name
  rfc2136_key_secret     = var.rfc2136_key_secret
  rfc2136_tsig_algorithm = var.rfc2136_tsig_algorithm
}

module "gateway_installer" {
  source                 = "./modules/gateway_userdata_cloudinit"
  location_info          = local.location_info
  vm_mutual_keypair      = tls_private_key.vm_mutual_key
  gateway_username       = var.gateway_username
  desktop_username       = var.desktop_username
  ssl_certificate        = module.certified_hostname.certificate
  murmur_config          = local.murmur_config
  gateway_dns_hostname   = module.certified_hostname.full_hostname
  email_config           = local.email_config
  docker_compose_release = local.docker_compose_release
}

locals {
  encoded_gateway_config = base64gzip(module.gateway_installer.unencoded_config)
}

module "oracle_infrastructure" {
  source                     = "./modules/shared_infrastructure_oci"
  tenancy_ocid               = var.tenancy_ocid
  user_ocid                  = var.user_ocid
  region                     = var.region
  availibility_domain_number = var.free_tier_available_in
  compartment_name           = module.certified_hostname.subdomain_label
  deployment_tags            = local.deployment_tags
}

module "gateway_machine" {
  source         = "./modules/gateway_infrastructure_oci"
  compartment    = module.oracle_infrastructure.compartment
  location_info  = local.location_info
  network_config = module.oracle_infrastructure.network_config
  vm_specs = {
    compute_shape   = var.gateway_shape
    source_image_id = module.oracle_infrastructure.source_image.id
  }
  gateway_username  = var.gateway_username
  murmur_config     = local.murmur_config
  email_config      = local.email_config
  encoded_userdata  = local.encoded_gateway_config
  vm_mutual_keypair = tls_private_key.vm_mutual_key
}

resource "tls_private_key" "vm_mutual_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

module "desktop_installer" {
  source               = "./modules/desktop_userdata_cloudinit"
  location_info        = local.location_info
  vm_mutual_keypair    = tls_private_key.vm_mutual_key
  gateway_username     = var.gateway_username
  desktop_username     = var.desktop_username
  murmur_config        = local.murmur_config
  gateway_dns_hostname = module.certified_hostname.full_hostname
  email_config         = local.email_config
}

locals {
  encoded_desktop_config = base64gzip(module.desktop_installer.unencoded_config)
}

module "desktop_machine_1" {
  source = "./modules/desktop_infrastructure_oci"
  depends_on = [
    # Desktop without gateway would be of little use
    module.gateway_installer
  ]
  compartment    = module.oracle_infrastructure.compartment
  location_info  = local.location_info
  network_config = module.oracle_infrastructure.network_config
  vm_specs = {
    compute_shape   = var.desktop_shape
    source_image_id = module.oracle_infrastructure.source_image.id
  }
  desktop_username    = var.desktop_username
  murmur_config       = local.murmur_config
  email_config        = local.email_config
  encoded_userdata    = local.encoded_desktop_config
  vm_mutual_keypair   = tls_private_key.vm_mutual_key
  gitlab_runner_token = "JW6YYWLG4mTsr_-mSaz8"
}