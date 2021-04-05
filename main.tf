locals {
  deployment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }
}

module "oracle_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/jafudi/commons/oci"
  version         = "1.0.0"
  // below variables are provider specific
  tenancy_ocid               = var.oci_tenancy_ocid
  user_ocid                  = var.oci_user_ocid
  region                     = var.oci_region
  availibility_domain_number = var.oci_free_tier_avail
  compartment_name           = var.TFC_WORKSPACE_NAME
}

module "amazon_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/jafudi/commons/aws"
  version         = "1.0.0"
}

module "credentials_generator" {
  registered_domain     = var.registered_domain
  subdomain_proposition = var.TFC_WORKSPACE_NAME
  gateway_cloud_info    = module.amazon_infrastructure.additional_metadata
  desktop_cloud_info    = module.oracle_infrastructure.additional_metadata
  source                = "./modules/terraform-tls-credentials"
  // below variables are provider specific
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
  primary_nic_name       = module.credentials_generator.gateway_primary_nic_name
  ssl_certificate        = module.credentials_generator.letsencrypt_certificate
  murmur_config          = module.credentials_generator.murmur_credentials
  gateway_dns_hostname   = module.credentials_generator.full_hostname
  email_config           = module.credentials_generator.email_config
  docker_compose_release = local.docker_compose_release
  mumbling_mole_version  = local.mumbling_mole_version
  first_vnc_port         = module.credentials_generator.vnc_port
  source                 = "git::ssh://git@gitlab.com/Jafudi/terraform-cloudinit-station.git?ref=master"
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
  source  = "app.terraform.io/jafudi/gateway/aws"
  version = "1.0.2"
  // below variables are provider specific
  cloud_provider_context = module.amazon_infrastructure.vm_creation_context
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
  primary_nic_name     = module.credentials_generator.desktop_primary_nic_name
  murmur_config        = module.credentials_generator.murmur_credentials
  browser_url          = module.credentials_generator.browser_url
  gateway_dns_hostname = module.credentials_generator.full_hostname
  email_config         = module.credentials_generator.email_config
  gateway_vnc_port     = module.credentials_generator.vnc_port
  source               = "app.terraform.io/jafudi/satellite/cloudinit"
  version              = "1.3.12"
}

locals {
  unzipped_desktop_bytes = length(module.desktop_installer.unzipped_config)
  encoded_desktop_config = base64gzip(module.desktop_installer.unzipped_config)
}

module "desktop_machine_1" {
  deployment_tags   = local.deployment_tags
  desktop_username  = module.credentials_generator.desktop_username
  encoded_userdata  = local.encoded_desktop_config
  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
  depends_on = [
    # Desktop without gateway would be of little use
    module.gateway_installer
  ]
  source  = "app.terraform.io/jafudi/desktop/oci"
  version = "1.0.0"
  // below variables are provider specific
  cloud_provider_context = module.oracle_infrastructure.vm_creation_context
}

resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/" #,
    #"/desktop-traffic/"
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
