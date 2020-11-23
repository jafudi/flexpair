variable "vm_mutual_keypair" {
  type = object({
    private_key_pem    = string
    public_key_openssh = string
  })
}

variable "vm_specs" {
  type = object({
    compute_shape   = string
    source_image_id = string
  })
}

variable "location_info" {
  type = object({
    cloud_region     = string
    data_center_name = string
    timezone_name    = string
    locale_settings  = string
  })
}

variable "deployment_tags" {
  type = map(string)
}

variable "network_config" {
  type = object({
    subnet_id              = string
    vpc_security_group_ids = list(string)
  })
}

variable "murmur_config" {
  type = object({
    port     = number
    password = string
  })
}

variable "email_config" {
  type = object({
    address   = string
    password  = string
    imap_port = number
    smtp_port = number
  })
}

variable "gateway_username" {
  type = string
}

variable "encoded_userdata" {
  type = string
  validation {
    condition     = length(var.encoded_userdata) < 32000
    error_message = "Oracle Cloud limits userdata to 32000 bytes."
  }
}
