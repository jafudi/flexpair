locals {
  valid_subdomain = lower(replace(var.subdomain_proposition,"/[_\\W]/","-"))

  full_hostname     = "${local.valid_subdomain}.${var.registered_domain}"

  email_address = "mail@${local.full_hostname}"
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
  common_name     = local.full_hostname
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