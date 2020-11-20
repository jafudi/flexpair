variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "region" {}

variable "private_key" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_password" {
  type = string
}

variable "timezone" {
  type        = string
  description = "The name of the common system time zone applied to both VMs"

  validation {
    condition     = can(regex("^[a-zA-Z_-]{1,14}/[a-zA-Z_-]{1,14}$", var.timezone))
    error_message = "This does not look like a valid IANA time zone. Please choose from e.g. https://en.wikipedia.org/wiki/List_of_tz_database_time_zones."
  }
}

variable "locale" {
  type = string
}

// https://www.terraform.io/docs/cloud/run/run-environment.html#environment-variables
variable "TFC_CONFIGURATION_VERSION_GIT_BRANCH" {}
variable "TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA" {}
variable "TFC_RUN_ID" {}

variable "free_tier_available_in" {
  type = number
}

variable "TFC_WORKSPACE_NAME" {
  type = string
}

variable "registered_domain" {}

variable "rfc2136_name_server" {
  type = string
}

variable "rfc2136_key_name" {
  type = string
}

variable "rfc2136_key_secret" {
  type = string
}

variable "rfc2136_tsig_algorithm" {
  type = string
}

variable "gateway_shape" {
  type = string
}
variable "desktop_shape" {
  type = string
}

