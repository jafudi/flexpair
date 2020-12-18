variable "gateway_cloud_info" {
  description = ""
  type = object({
    cloud_account_name     = string
    source_image_info      = string
    network_interface_name = string
  })
}

variable "desktop_cloud_info" {
  description = ""
  type = object({
    cloud_account_name     = string
    source_image_info      = string
    network_interface_name = string
  })
}

variable "registered_domain" {
  description = ""
  type        = string
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid registered domain."
  }
}

variable "subdomain_proposition" {
  description = ""
  type        = string
}

variable "rfc2136_name_server" {
  description = ""
  type        = string
}

variable "rfc2136_key_name" {
  description = ""
  type        = string
}

variable "rfc2136_key_secret" {
  description = ""
  type        = string
}

variable "rfc2136_tsig_algorithm" {
  description = ""
  type        = string
}
