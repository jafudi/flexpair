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
  compartment_name           = var.TFC_WORKSPACE_NAME
  deployment_tags            = local.deployment_tags
}

module "amazon_infrastructure" {
  source          = "./modules/shared_infrastructure_aws"
  deployment_tags = local.deployment_tags
}

module "credentials_generator" {
  source                 = "./modules/credentials_generator"
  gateway_username       = module.amazon_infrastructure.account_name
  desktop_username       = module.oracle_infrastructure.account_name
  registered_domain      = var.registered_domain
  subdomain_proposition  = "${var.TFC_CONFIGURATION_VERSION_GIT_BRANCH}-branch-${var.TFC_WORKSPACE_NAME}"
  rfc2136_name_server    = var.rfc2136_name_server
  rfc2136_key_name       = var.rfc2136_key_name
  rfc2136_key_secret     = var.rfc2136_key_secret
  rfc2136_tsig_algorithm = var.rfc2136_tsig_algorithm
}

locals {
  location_info = {
    cloud_region     = var.oci_region
    data_center_name = module.oracle_infrastructure.availability_domain_name
    timezone_name    = var.timezone
    locale_settings  = var.locale
  }
}

module "gateway_installer" {
  source                 = "./modules/gateway_userdata_cloudinit"
  location_info          = local.location_info
  vm_mutual_keypair      = module.credentials_generator.vm_mutual_key
  gateway_username       = module.credentials_generator.gateway_username
  desktop_username       = module.credentials_generator.desktop_username
  ssl_certificate        = module.credentials_generator.letsencrypt_certificate
  murmur_config          = module.credentials_generator.murmur_credentials
  gateway_dns_hostname   = module.credentials_generator.full_hostname
  email_config           = module.credentials_generator.email_config
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
  gateway_username  = module.credentials_generator.gateway_username
  murmur_config     = module.credentials_generator.murmur_credentials
  email_config      = module.credentials_generator.email_config
  encoded_userdata  = local.encoded_gateway_config
  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
  depends_on        = [module.amazon_infrastructure]
}

resource "dns_a_record_set" "gateway_hostname" {
  zone      = "${var.registered_domain}."
  name      = module.credentials_generator.subdomain_label
  addresses = [module.gateway_machine.public_ip]
  ttl       = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dns_a_record_set.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = module.credentials_generator.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}

module "desktop_installer" {
  source               = "./modules/desktop_userdata_cloudinit"
  location_info        = local.location_info
  vm_mutual_keypair    = module.credentials_generator.vm_mutual_key
  gateway_username     = module.credentials_generator.gateway_username
  desktop_username     = module.credentials_generator.desktop_username
  murmur_config        = module.credentials_generator.murmur_credentials
  gateway_dns_hostname = module.credentials_generator.full_hostname
  email_config         = module.credentials_generator.email_config
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
  desktop_username    = module.credentials_generator.desktop_username
  murmur_config       = module.credentials_generator.murmur_credentials
  email_config        = module.credentials_generator.email_config
  encoded_userdata    = local.encoded_desktop_config
  vm_mutual_keypair   = module.credentials_generator.vm_mutual_key
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
    module.desktop_machine_1,
    time_sleep.dns_propagation
  ]

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --tries=30 --spider --recursive --level 1 https://${module.credentials_generator.full_hostname}${each.key};"
  }
}