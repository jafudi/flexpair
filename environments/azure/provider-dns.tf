provider "dnsimple" {
  token   = var.dnsimple_account_token
  account = var.dnsimple_account_id
}

variable "dnsimple_account_id" {
  description = ""
  type        = number
}

variable "dnsimple_account_token" {
  description = ""
  type        = string
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
