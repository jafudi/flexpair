resource "tls_private_key" "vm_mutual_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "random_password" "imap_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
}

resource "random_password" "murmur_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
  keepers = {
    gateway_replacement_trigger = var.gateway_context_hash
  }
}

resource "random_password" "guacamole_admin_name" {
  length  = 9
  special = false
  keepers = {
    gateway_replacement_trigger = var.gateway_context_hash
  }
}

resource "random_integer" "murmur_port" {
  max = 65535
  min = 10000
  keepers = {
    gateway_replacement_trigger = var.gateway_context_hash
  }
}

resource "random_integer" "vnc_port" {
  max = 5999
  min = 5900
}

locals {
  murmur_credentials = {
    port     = random_integer.murmur_port.result
    password = random_password.murmur_password.result
  }

  guacamole_credentials = {
    guacamole_endpoint_url   = "https://${var.full_hostname}/guacamole"
    guacamole_admin_username = random_password.guacamole_admin_name.result
    guacamole_admin_password = "guacadmin"
  }

  first_vnc_crendentials = {
    title    = "Shared Desktop 1 ( ...some useful hints... )"
    hostname = "gateway"
    vnc_port = random_integer.vnc_port.result
    username = "jafudi"
    password = "jafudi"
  }

  email_config = {
    address   = "mail@${var.full_hostname}"
    password  = random_password.imap_password.result
    imap_port = 143
    smtp_port = 25
  }
}

resource "tls_private_key" "acme_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "letsencrypt_reg" {
  account_key_pem = tls_private_key.acme_private_key.private_key_pem
  email_address   = local.email_config.address
}

resource "acme_certificate" "letsencrypt_certificate" {
  account_key_pem           = acme_registration.letsencrypt_reg.account_key_pem
  common_name               = var.full_hostname
  subject_alternative_names = var.demo_hostname != null ? [var.demo_hostname] : null
  key_type                  = 4096

  dns_challenge {
    provider = "dnsimple"
    config = {
      DNSIMPLE_OAUTH_TOKEN = var.dnsimple_account_token # OAuth token.
      # DNSIMPLE_POLLING_INTERVAL = # Time between DNS propagation check.
      # DNSIMPLE_PROPAGATION_TIMEOUT = # Maximum waiting time for DNS propagation.
      # DNSIMPLE_TTL = # The TTL of the TXT record used for the DNS challenge.
    }
  }
}
