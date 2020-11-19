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

variable "compartment" {
  type = object({
    id            = string
    freeform_tags = map(string)
  })
}

variable "network_config" {
  type = object({
    vcn_id          = string
    route_table_id  = string
    dhcp_options_id = string
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
    password   = string
    imap_port = number
    smtp_port = number
  })
}

variable "desktop_username" {
  type        = string
}

variable "gitlab_runner_token" {
  type = string
}

variable "encoded_userdata" {
  type = string
}