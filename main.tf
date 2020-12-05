locals {
  deployment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }
}

module "oracle_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "./modules/shared_infrastructure_oci"
  // below variables are specific to OCI and should be prefixed accordingly
  tenancy_ocid               = var.oci_tenancy_ocid
  user_ocid                  = var.oci_user_ocid
  region                     = var.oci_region
  availibility_domain_number = var.oci_free_tier_avail
  compartment_name           = var.TFC_WORKSPACE_NAME
}

module "amazon_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "./modules/shared_infrastructure_aws"
  // below variables are specific to AWS and should be prefixed accordingly
}

module "credentials_generator" {
  registered_domain     = var.registered_domain
  subdomain_proposition = "${var.TFC_CONFIGURATION_VERSION_GIT_BRANCH}-branch-${var.TFC_WORKSPACE_NAME}"
  gateway_username      = module.amazon_infrastructure.cloud_account_name
  desktop_username      = module.oracle_infrastructure.cloud_account_name
  source                = "./modules/credentials_generator"
  // below variables are specific to dynv6.com DNS as an RFC2136 implementation
  rfc2136_name_server    = var.rfc2136_name_server
  rfc2136_key_name       = var.rfc2136_key_name
  rfc2136_key_secret     = var.rfc2136_key_secret
  rfc2136_tsig_algorithm = var.rfc2136_tsig_algorithm
}

module "gateway_installer" {
  timezone_name          = var.timezone
  locale_name            = var.locale
  vm_mutual_keypair      = module.credentials_generator.vm_mutual_key
  gateway_username       = module.credentials_generator.gateway_username
  desktop_username       = module.credentials_generator.desktop_username
  ssl_certificate        = module.credentials_generator.letsencrypt_certificate
  murmur_config          = module.credentials_generator.murmur_credentials
  gateway_dns_hostname   = module.credentials_generator.full_hostname
  email_config           = module.credentials_generator.email_config
  docker_compose_release = local.docker_compose_release
  source                 = "./modules/gateway_userdata_cloudinit"
}

locals {
  unzipped_gateway_bytes = length(module.gateway_installer.unzipped_config)
  encoded_gateway_config = base64gzip(module.gateway_installer.unzipped_config)
}

module "gateway_machine" {
  deployment_tags   = local.deployment_tags
  gateway_username  = module.credentials_generator.gateway_username
  encoded_userdata  = local.encoded_gateway_config
  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
  open_tcp_ports = {
    ssh    = 22
    https  = 443
    http   = 80
    mumble = module.credentials_generator.murmur_credentials.port
    smtp   = module.credentials_generator.email_config.smtp_port
  }
  source = "./modules/gateway_infrastructure_oci"
  // below variables are specific to AWS and should be prefixed accordingly
  cloud_provider_context = module.oracle_infrastructure.vm_instance_context
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
  timezone_name        = var.timezone
  locale_name          = var.locale
  vm_mutual_keypair    = module.credentials_generator.vm_mutual_key
  gateway_username     = module.credentials_generator.gateway_username
  desktop_username     = module.credentials_generator.desktop_username
  murmur_config        = module.credentials_generator.murmur_credentials
  gateway_dns_hostname = module.credentials_generator.full_hostname
  email_config         = module.credentials_generator.email_config
  source               = "./modules/desktop_userdata_cloudinit"
}

locals {
  unzipped_desktop_bytes = length(module.desktop_installer.unzipped_config)
  encoded_desktop_config = base64gzip(module.desktop_installer.unzipped_config)
}

module "desktop_machine_1" {
  deployment_tags   = local.deployment_tags
  desktop_username  = module.credentials_generator.desktop_username
  murmur_config     = module.credentials_generator.murmur_credentials
  email_config      = module.credentials_generator.email_config
  encoded_userdata  = local.encoded_desktop_config
  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
  depends_on = [
    # Desktop without gateway would be of little use
    module.gateway_installer
  ]
  source = "./modules/desktop_infrastructure_aws"
  // below variables are specific to OCI and should be prefixed accordingly
  cloud_provider_context = module.amazon_infrastructure.vm_instance_context
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