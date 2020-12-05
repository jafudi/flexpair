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

variable "oci_availability_zone" {
  type = string
}

variable "compartment" {
  type = object({
    id            = string
    freeform_tags = map(string)
  })
}

variable "network_config" {
  type = object({
    vcn_id           = string
    route_table_id   = string
    dhcp_options_id  = string
    security_list_id = string
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

variable "open_tcp_ports" {
  type = map(number)
  default = {}
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
