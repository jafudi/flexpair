variable "gateway_cloud_info" {
  type = object({
    cloud_provider_name    = string
    cloud_account_name     = string
    source_image_info      = string
    network_interface_name = string
  })
}

variable "desktop_cloud_info" {
  type = object({
    cloud_provider_name    = string
    cloud_account_name     = string
    source_image_info      = string
    network_interface_name = string
  })
}

variable "registered_domain" {
  type = string

  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid registered domain."
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
