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