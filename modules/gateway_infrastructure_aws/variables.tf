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

variable "deployment_tags" {
  type = map(string)
}

variable "network_config" {
  type = object({
    vpc_id                 = string
    subnet_id              = string
    shared_security_group_id = string
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
