// https://registry.terraform.io/providers/hashicorp/dns/latest/docs

provider "dns" {
  update {
    server        = var.rfc2136_name_server
    key_name      = var.rfc2136_key_name
    key_algorithm = var.rfc2136_tsig_algorithm
    key_secret    = var.rfc2136_key_secret
  }
}

provider "acme" {
  # 50 certificates per registered domain per week
  # as per https://letsencrypt.org/docs/rate-limits/
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "registered_domain" {
  type        = string
  default     = "jafudi.de" // Registered through internetwerk.de
  description = "A registered domain pointing to rfc2136_name_server."
}

variable "rfc2136_name_server" {
  type        = string
  default     = "ns1.dynv6.com"
  description = "Offers full implementation of RFC2136 and TSIG for free"
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.rfc2136_name_server))
    error_message = "This does not look like a valid domain for a name server."
  }
}

variable "rfc2136_key_name" {
  description = ""
  type        = string
  default     = "tsig-164066.dynv6.com."
}

variable "rfc2136_key_secret" {
  type        = string
  default     = "7I57AtxCp7PHfAfWsV9TviS+B3glddd9PGoBMo1bYBSicoKM3BdaQL9qnZBX7uy6Vi8r+46/HmOrMq767RRTPA=="
  description = "Sensitive, yet no cost risk"
}

variable "rfc2136_tsig_algorithm" {
  description = ""
  type        = string
  default     = "hmac-sha512"
  validation {
    condition     = contains(["hmac-sha224", "hmac-sha256", "hmac-sha384", "hmac-sha512"], var.rfc2136_tsig_algorithm)
    error_message = "Unsupported algorithm specified."
  }
}
