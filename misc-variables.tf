

variable "timezone" {
  type        = string
  default     = "Europe/Berlin"
  description = "The name of the common system time zone applied to both VMs"

  validation {
    condition     = can(regex("^[a-zA-Z_-]{1,14}/[a-zA-Z_-]{1,14}$", var.timezone))
    error_message = "This does not look like a valid IANA time zone. Please choose from e.g. https://en.wikipedia.org/wiki/List_of_tz_database_time_zones."
  }
}

variable "locale" {
  type    = string
  default = "de_DE.UTF-8"
}

// https://www.terraform.io/docs/cloud/run/run-environment.html#environment-variables
variable "TFC_CONFIGURATION_VERSION_GIT_BRANCH" {}
variable "TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA" {}
variable "TFC_RUN_ID" {}

variable "TFC_WORKSPACE_NAME" {
  type = string
}



