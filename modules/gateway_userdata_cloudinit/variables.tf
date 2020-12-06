variable "vm_mutual_keypair" {
  type = object({
    private_key_pem    = string
    public_key_openssh = string
  })
}

variable "ssl_certificate" {
  type = object({
    private_key_pem = string
    certificate_pem = string
    issuer_pem      = string
  })
}

variable "docker_compose_release" {
  type = string
}

variable "gateway_dns_hostname" {
  type = string
}

variable "desktop_username" {
  type        = string
  description = "Username for logging in to Ubuntu on the desktop node"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.desktop_username))
    error_message = "The desktop username should start with a lowercase letter or an underscore. The following 31 letters may also contain numbers and hyphens."
  }
}

variable "gateway_username" {
  type        = string
  description = "Username for logging in to Ubuntu on the gateway node"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.gateway_username))
    error_message = "The gateway username should start with a lowercase letter or an underscore. The following 31 letters may also contain numbers and hyphens."
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

variable "timezone_name" {
  type        = string
  default     = "Europe/Berlin"
  description = "The name of the common system time zone applied to both VMs"

  validation {
    condition     = can(regex("^[a-zA-Z_-]{1,14}/[a-zA-Z_-]{1,14}$", var.timezone_name))
    error_message = "This does not look like a valid IANA time zone. Please choose from e.g. https://en.wikipedia.org/wiki/List_of_tz_database_time_zones."
  }
}

variable "locale_name" {
  type    = string
  default = "de_DE.UTF-8"
}

variable "primary_nic_name" {
  type = string
}
