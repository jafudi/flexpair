variable "registered_domain" {
  type        = string
  description = "A registered domain pointing to rfc2136_name_server."

  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid domain."
  }
}

variable "subdomain_proposition" {
  type = string
}

variable "rfc2136_name_server" {
  type = string
}

variable "rfc2136_key_name" {
  type = string
}

variable "rfc2136_key_secret" {
  type = string
}

variable "rfc2136_tsig_algorithm" {
  type = string
}