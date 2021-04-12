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

variable "full_hostname" {
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
