variable "deployment_tags" {
  description = ""
  type        = map(string)
}

variable "cloud_provider_context" {
  description = ""
  type = object({
    vcn_id                   = string
    route_table_id           = string
    dhcp_options_id          = string
    security_list_id         = string
    availability_domain_name = string
    compartment_id           = string
    source_image_id          = string
    minimum_viable_shape     = string
  })
}


variable "vm_mutual_keypair" {
  description = ""
  type = object({
    private_key_pem    = string
    public_key_openssh = string
  })
}

variable "desktop_username" {
  description = ""
  type        = string
}

variable "encoded_userdata" {
  description = ""
  type        = string
  validation {
    condition     = length(var.encoded_userdata) < 32000
    error_message = "Oracle Cloud limits userdata to 32000 bytes."
  }
}