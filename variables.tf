variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "region" {
}

variable "private_key" {
}

variable "fingerprint" {
}

variable "private_key_password" {
}

variable "timezone" {}

variable "locale" {}

// https://www.terraform.io/docs/cloud/run/run-environment.html#environment-variables
variable "TFC_CONFIGURATION_VERSION_GIT_BRANCH" {}
variable "TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA" {}
variable "TFC_RUN_ID" {}

variable "free_tier_available_in" {
}

variable "TFC_WORKSPACE_NAME" {}

variable "registered_domain" {}

variable "rfc2136_name_server" {}

variable "rfc2136_key_name" {}

variable "rfc2136_key_secret" {}

variable "rfc2136_tsig_algorithm" {}

variable "gateway_shape" {}
variable "desktop_shape" {}

variable "desktop_username" {
  type        = string
  description = "Username for logging in to Ubuntu on the desktop node"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.desktop_username))
    error_message = "Desktop username should start with a lowercase letter or an underscore. The following 31 letters may also contain numbers and hyphens."
  }
}

variable "gateway_username" {
  type        = string
  description = "Username for logging in to Ubuntu on the gateway node"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.gateway_username))
    error_message = "Gateway username should start with a lowercase letter or an underscore. The following 31 letters may also contain numbers and hyphens."
  }
}
