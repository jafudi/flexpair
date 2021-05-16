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
  default     = "pairpac.com" // Registered through internetwerk.de
  description = "A registered domain pointing to rfc2136_name_server."
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid registered domain."
  }
}

variable "rfc2136_name_server" {
  type        = string
  default     = "ns1.dynv6.com"
  description = "The IPv4 address or URL of the DNS server to send updates to"
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.rfc2136_name_server))
    error_message = "This does not look like a valid domain for a name server."
  }
}

variable "rfc2136_key_name" {
  description = "The name of the TSIG key used to sign the DNS update messages"
  type        = string
  default     = "tsig-224951.dynv6.com."
}

variable "rfc2136_key_secret" {
  type        = string
  default     = "wg46X5+cZJdF7rwInheeqPv/NK56d0Oj+m7LCbuG0186tgxlvgzWR3qoynQAbpG68272pT5HutAzbbqI+IxWgA=="
  description = "A Base64-encoded string containing the shared secret to be used for TSIG"
}

variable "rfc2136_tsig_algorithm" {
  description = "When using TSIG authentication, the algorithm to use for HMAC"
  type        = string
  default     = "hmac-sha512"
  validation {
    condition     = contains(["hmac-sha224", "hmac-sha256", "hmac-sha384", "hmac-sha512"], var.rfc2136_tsig_algorithm)
    error_message = "Unsupported algorithm specified."
  }
}
