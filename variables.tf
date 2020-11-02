variable "tenancy_ocid" {
  type        = string
  description = "Oracle Cloud ID (OCID) of the tenancy"

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.[a-z0-9\\.]+", var.tenancy_ocid))
    error_message = "This does not look like a valid OCID for a tenancy. Please refer to https://jafudi.net/ocid for detailed guidance."
  }
}

variable "user_ocid" {
  type        = string
  description = "The user's Oracle Cloud ID (OCID)"

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.[a-z0-9\\.]+", var.user_ocid))
    error_message = "This does not look like a valid OCID for a user. Please refer to https://jafudi.net/ocid for detailed guidance."
  }
}

variable "region" {
  type = string
}

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

variable "registered_domain" {
  type = string
}

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
