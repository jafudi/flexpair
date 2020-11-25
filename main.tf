module "certified_hostname" {
  source                 = "./modules/certified_dns_hostname"
  registered_domain      = var.registered_domain
  subdomain_proposition  = "${var.TFC_CONFIGURATION_VERSION_GIT_BRANCH}-branch-${var.TFC_WORKSPACE_NAME}"
  rfc2136_name_server    = var.rfc2136_name_server
  rfc2136_key_name       = var.rfc2136_key_name
  rfc2136_key_secret     = var.rfc2136_key_secret
  rfc2136_tsig_algorithm = var.rfc2136_tsig_algorithm
}

locals {
  deployment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }
}

module "oracle_infrastructure" {
  source                     = "./modules/shared_infrastructure_oci"
  tenancy_ocid               = var.oci_tenancy_ocid
  user_ocid                  = var.oci_user_ocid
  region                     = var.oci_region
  availibility_domain_number = var.oci_free_tier_avail
  compartment_name           = module.certified_hostname.subdomain_label
  deployment_tags            = local.deployment_tags
}

module "amazon_infrastructure" {
  source                     = "./modules/shared_infrastructure_aws"
  tenancy_ocid               = var.oci_tenancy_ocid
  user_ocid                  = var.oci_user_ocid
  region                     = var.oci_region
  availibility_domain_number = var.oci_free_tier_avail
  compartment_name           = module.certified_hostname.subdomain_label
  deployment_tags            = local.deployment_tags
}

locals {
  location_info = {
    cloud_region     = var.oci_region
    data_center_name = module.oracle_infrastructure.availability_domain_name
    timezone_name    = var.timezone
    locale_settings  = var.locale
  }

  gateway_username = module.oracle_infrastructure.tenancy_name
  desktop_username = module.oracle_infrastructure.tenancy_name
}

module "shared_secrets" {
  source = "./modules/shared_secrets"
}

locals {
  email_config = {
    address   = "${local.desktop_username}@${module.certified_hostname.full_hostname}"
    password  = module.shared_secrets.imap_password
    imap_port = 143
    smtp_port = 25
  }

  murmur_config = {
    port     = 53123 // must be less than or equal to 65535
    password = module.shared_secrets.murmur_password
  }
}

module "gateway_installer" {
  source                 = "./modules/gateway_userdata_cloudinit"
  location_info          = local.location_info
  vm_mutual_keypair      = module.shared_secrets.vm_mutual_key
  gateway_username       = local.gateway_username
  desktop_username       = local.desktop_username
  ssl_certificate        = module.certified_hostname.certificate
  murmur_config          = local.murmur_config
  gateway_dns_hostname   = module.certified_hostname.full_hostname
  email_config           = local.email_config
  docker_compose_release = local.docker_compose_release
}

locals {
  unzipped_gateway_bytes = length(module.gateway_installer.unzipped_config)
  encoded_gateway_config = base64gzip(module.gateway_installer.unzipped_config)
}

module "gateway_machine" {
  source          = "./modules/gateway_infrastructure_aws"
  deployment_tags = local.deployment_tags
  location_info   = local.location_info
  network_config  = module.amazon_infrastructure.network_config
  vm_specs = {
    compute_shape   = module.amazon_infrastructure.minimum_viable_shape
    source_image_id = module.amazon_infrastructure.source_image.id
  }
  gateway_username  = local.gateway_username
  murmur_config     = local.murmur_config
  email_config      = local.email_config
  encoded_userdata  = local.encoded_gateway_config
  vm_mutual_keypair = module.shared_secrets.vm_mutual_key
  depends_on        = [module.amazon_infrastructure]
}

resource "dns_a_record_set" "gateway_hostname" {
  zone      = "${var.registered_domain}."
  name      = module.certified_hostname.subdomain_label
  addresses = [module.gateway_machine.public_ip]
  ttl       = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dns_a_record_set.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = module.certified_hostname.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}

module "desktop_installer" {
  source               = "./modules/desktop_userdata_cloudinit"
  location_info        = local.location_info
  vm_mutual_keypair    = module.shared_secrets.vm_mutual_key
  gateway_username     = local.gateway_username
  desktop_username     = local.desktop_username
  murmur_config        = local.murmur_config
  gateway_dns_hostname = module.certified_hostname.full_hostname
  email_config         = local.email_config
}

locals {
  unzipped_desktop_bytes = length(module.desktop_installer.unzipped_config)
  encoded_desktop_config = base64gzip(module.desktop_installer.unzipped_config)
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
    compute_shape   = module.oracle_infrastructure.minimum_viable_shape
    source_image_id = module.oracle_infrastructure.source_image.id
  }
  desktop_username    = local.desktop_username
  murmur_config       = local.murmur_config
  email_config        = local.email_config
  encoded_userdata    = local.encoded_desktop_config
  vm_mutual_keypair   = module.shared_secrets.vm_mutual_key
  gitlab_runner_token = "JW6YYWLG4mTsr_-mSaz8"
}

resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/",
    "/desktop-traffic/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    module.gateway_machine,
    //    module.desktop_machine_1,
    time_sleep.dns_propagation
  ]

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --tries=30 --spider --recursive --level 1 https://${module.certified_hostname.full_hostname}${each.key};"
  }
}