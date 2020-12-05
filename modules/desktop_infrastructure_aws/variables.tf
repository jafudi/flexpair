variable "cloud_provider_context" {
  type = object({
    vpc_id                   = string
    subnet_id                = string
    shared_security_group_id = string
    source_image_id          = string
    minimum_viable_shape     = string
  })
}

variable "vm_mutual_keypair" {
  type = object({
    private_key_pem    = string
    public_key_openssh = string
  })
}

variable "deployment_tags" {
  type = map(string)
}

variable "desktop_username" {
  type = string
}

variable "encoded_userdata" {
  type = string
  validation {
    condition     = length(var.encoded_userdata) < 16384
    error_message = "AWS limits userdata to 16384 bytes."
  }
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
