locals {

  deployment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }

  location_info = {
    cloud_region     = var.region
    data_center_name = module.oracle_infrastructure.availability_domain_name
    timezone_name    = var.timezone
    locale_settings  = var.locale
  }

  email_config = {
    address   = "${var.desktop_username}@${module.certified_hostname.full_hostname}"
    password  = random_string.imap_password.result
    imap_port = 143
    smtp_port = 25
  }

  murmur_config = {
    port     = 53123 // must be less than or equal to 65535
    password = random_string.murmur_password.result
  }
}

resource "random_string" "imap_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
  keepers = {
    # Generate a new password each time we change the web address
    user_facing_web_address = module.certified_hostname.full_hostname
  }
}

resource "random_string" "murmur_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
  keepers = {
    # Generate a new password each time we change the web address
    user_facing_web_address = module.certified_hostname.full_hostname
  }
}

