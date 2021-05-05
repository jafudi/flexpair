resource "random_pet" "subdomain" {
  length    = 2
  separator = "-"
}

locals {
  deployment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }

  org_list        = split("/", var.TFC_WORKSPACE_SLUG)
  organization    = local.org_list[0]
  workspace       = local.org_list[1]
  valid_subdomain = random_pet.subdomain.id # in PROD: lower(replace(local.workspace, "/[_\\W]/", "-"))
  full_hostname   = "${local.valid_subdomain}.${var.registered_domain}"
}

module "oracle_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/jafudi/commons/oci"
  version         = "1.1.0"
  // below variables are provider specific
  tenancy_ocid               = var.oci_tenancy_ocid
  user_ocid                  = var.oci_user_ocid
  region                     = var.oci_region
  availibility_domain_number = var.oci_free_tier_avail
  compartment_name           = local.workspace
}

module "amazon_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/jafudi/commons/aws"
  version         = "1.0.0"
}

module "credentials_generator" {
  full_hostname      = local.full_hostname
  gateway_cloud_info = module.amazon_infrastructure.additional_metadata
  desktop_cloud_info = module.oracle_infrastructure.additional_metadata
  source             = "../modules/terraform-tls-credentials"
  // below variables are provider specific
  rfc2136_name_server    = var.rfc2136_name_server
  rfc2136_key_name       = var.rfc2136_key_name
  rfc2136_key_secret     = var.rfc2136_key_secret
  rfc2136_tsig_algorithm = var.rfc2136_tsig_algorithm
}

# TODO: Fully parameterize VNC crendetials
# TODO: Fully parameterize Guacamole credentials
module "gateway_installer" {
  timezone_name          = var.timezone
  locale_name            = var.locale
  vm_mutual_keypair      = module.credentials_generator.vm_mutual_key
  gateway_username       = module.credentials_generator.gateway_username
  desktop_username       = module.credentials_generator.desktop_username
  primary_nic_name       = module.credentials_generator.gateway_primary_nic_name
  ssl_certificate        = module.credentials_generator.letsencrypt_certificate
  murmur_config          = module.credentials_generator.murmur_credentials
  gateway_dns_hostname   = local.full_hostname
  email_config           = module.credentials_generator.email_config
  docker_compose_release = local.docker_compose_release
  mumbling_mole_version  = local.mumbling_mole_version
  first_vnc_port         = module.credentials_generator.vnc_credentials.vnc_port
  guacamole_admin        = module.credentials_generator.guacamole_credentials.guacamole_admin_username
  source                 = "git::ssh://git@gitlab.com/Jafudi/terraform-cloudinit-station.git?ref=master"
}

# TODO: Fully parameterize VNC crendetials
module "desktop_installer" {
  timezone_name        = var.timezone
  locale_name          = var.locale
  vm_mutual_keypair    = module.credentials_generator.vm_mutual_key
  gateway_username     = module.credentials_generator.gateway_username
  desktop_username     = module.credentials_generator.desktop_username
  primary_nic_name     = module.credentials_generator.desktop_primary_nic_name
  murmur_config        = module.credentials_generator.murmur_credentials
  browser_url          = module.credentials_generator.browser_url
  gateway_dns_hostname = local.full_hostname
  email_config         = module.credentials_generator.email_config
  gateway_vnc_port     = module.credentials_generator.vnc_credentials.vnc_port
  source               = "git::ssh://git@gitlab.com/jafudi-group/terraform-cloudinit-satellite.git?ref=master"
}

locals {
  unzipped_desktop_bytes = length(module.desktop_installer.unzipped_config)
  encoded_desktop_config = module.desktop_installer.encoded_config
  unzipped_gateway_bytes = length(module.gateway_installer.unzipped_config)
  encoded_gateway_config = module.gateway_installer.encoded_config
}

resource "local_file" "desktop_meta_data" {
  content  = "instance-id: iid-local01\nlocal-hostname: cloudimg"
  filename = "${path.root}/../uploads/desktop-config/meta-data"
}

resource "local_file" "desktop_user_data" {
  content  = module.desktop_installer.unzipped_config
  filename = "${path.root}/../uploads/desktop-config/user-data"
}

resource "null_resource" "desktop_config_iso" {

  depends_on = [
    local_file.desktop_meta_data,
    local_file.desktop_user_data
  ]

  provisioner "local-exec" {
    working_dir = "${path.root}/../uploads/desktop-config"
    interpreter = ["/bin/bash", "-c"]
    command     = "apt-get update; apt-get -qq install genisoimage; genisoimage  -output config.iso -volid cidata -joliet -rock user-data meta-data"
  }
}

module "gateway_machine" {
  depends_on = [
    null_resource.desktop_config_iso
  ]
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
  version = "1.0.6"
  // below variables are provider specific
  cloud_provider_context = module.amazon_infrastructure.vm_creation_context
}

resource "dns_a_record_set" "gateway_hostname" {
  zone      = "${var.registered_domain}."
  name      = local.valid_subdomain
  addresses = [module.gateway_machine.public_ip]
  ttl       = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dns_a_record_set.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = local.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}

//module "desktop_machine_1" {
//  deployment_tags   = local.deployment_tags
//  desktop_username  = module.credentials_generator.desktop_username
//  encoded_userdata  = local.encoded_desktop_config
//  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
//  depends_on = [
//    # Desktop without gateway would be of little use
//    module.gateway_installer
//  ]
//  source  = "app.terraform.io/jafudi/desktop/oci"
//  version = "1.0.1"
//  // below variables are provider specific
//  cloud_provider_context = module.oracle_infrastructure.vm_creation_context
//}

resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    module.gateway_machine,
    time_sleep.dns_propagation
  ]

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --tries=30 --spider --recursive --level 1 https://${local.full_hostname}${each.key};"
  }
}
