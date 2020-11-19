variable "vm_mutual_keypair" {
  type = object({
    private_key_pem    = string
    public_key_openssh = string
  })
}

variable "url" {
    type = object({
    proto_scheme      = string
    subdomain_label   = string
    registered_domain = string
    toplevel_domain   = string
    full_hostname     = string
  })
}

variable "murmur_config" {
  type = object({
    port     = number
    password = string
  })
}

variable "gateway_username" {
  type        = string
}

variable "desktop_username" {
  type        = string
}

variable "email_config" {
  type = object({
    address   = string
    password   = string
    imap_port = number
    smtp_port = number
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


