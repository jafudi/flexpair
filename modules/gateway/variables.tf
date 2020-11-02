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

variable "vm_mutual_keypair" {
  type = object({
    private_key_pem    = string
    public_key_openssh = string
  })
}

variable "network_config" {
  type = object({
    vcn_id          = string
    route_table_id  = string
    dhcp_options_id = string
  })
}

variable "ssl_certificate" {
  type = object({
    private_key_pem = string
    certificate_pem = string
    issuer_pem      = string
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

variable "url" {
    type = object({
    proto_scheme      = string
    subdomain_label   = string
    registered_domain = string
    toplevel_domain   = string
    full_hostname     = string
  })
}

variable "docker_compose_release" {
  type = string
}

variable "local_username" {
  type        = string
}

variable "remote_username" {
  type        = string
}