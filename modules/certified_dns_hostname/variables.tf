variable "registered_domain" {
  type        = string
  description = "A registered domain pointing to rfc2136_name_server."
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