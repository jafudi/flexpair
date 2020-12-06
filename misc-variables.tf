

variable "timezone" {
  type        = string
  default     = "Europe/Berlin"
  description = "The name of the common system time zone applied to both VMs"
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



