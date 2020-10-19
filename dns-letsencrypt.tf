variable "TFC_WORKSPACE_NAME" {}

variable "registered_domain" {}

variable "rfc2136_name_server" {}

variable "rfc2136_key_name" {}

variable "rfc2136_key_secret" {}

variable "rfc2136_tsig_algorithm" {}


# Configure the DNS Provider
provider "dns" {
  update {
    server        = var.rfc2136_name_server
    key_name      = var.rfc2136_key_name
    key_algorithm = var.rfc2136_tsig_algorithm
    key_secret    = var.rfc2136_key_secret
  }
}

locals {
  subdomain = lower("${var.TFC_CONFIGURATION_VERSION_GIT_BRANCH}-branch-${var.TFC_WORKSPACE_NAME}")
  domain    = "${local.subdomain}.${var.registered_domain}"
}

# Create a DNS A record set
resource "dns_a_record_set" "gateway_hostname" {
  zone      = "${var.registered_domain}."
  name      = local.subdomain
  addresses = [oci_core_instance.gateway.public_ip]
  ttl       = 60
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "acme_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "letsencrypt_reg" {
  account_key_pem = tls_private_key.acme_private_key.private_key_pem
  email_address   = local.email_address
}

resource "acme_certificate" "letsencrypt_certificate" {
  account_key_pem = acme_registration.letsencrypt_reg.account_key_pem
  common_name     = local.domain
  key_type        = 4096

  dns_challenge {
    provider = "rfc2136" // https://go-acme.github.io/lego/dns/
    config = {
      RFC2136_NAMESERVER = var.rfc2136_name_server
      // To disable TSIG authentication, leave the RFC2136_TSIG* variables unset.
      RFC2136_TSIG_ALGORITHM = "${var.rfc2136_tsig_algorithm}."
      RFC2136_TSIG_KEY       = var.rfc2136_key_name   // Name of the secret key as defined in DNS server configuration
      RFC2136_TSIG_SECRET    = var.rfc2136_key_secret // Secret key payload
      // RFC2136_DNS_TIMEOUT = "" // API request timeout.
      // RFC2136_POLLING_INTERVAL = "" // Time between DNS propagation check.
      // RFC2136_PROPAGATION_TIMEOUT = "" // Maximum waiting time for DNS propagation.
      // RFC2136_SEQUENCE_INTERVAL = "" // Interval between iteration.
      // RFC2136_TTL = "" // The time-to-live of the TXT record used for the DNS challenge.
    }
  }
}

locals {
  letsencrypt_chain   = acme_certificate.letsencrypt_certificate.issuer_pem
  acme_cert_fullchain = "${acme_certificate.letsencrypt_certificate.certificate_pem}${local.letsencrypt_chain}"
}