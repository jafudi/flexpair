variable "timezone" {
  type        = string
  default     = "Europe/Berlin"
  description = "The name of the common system time zone applied to both VMs"
}

variable "locale" {
  description = ""
  type        = string
  default     = "de_DE.UTF-8"
}

// https://www.terraform.io/docs/cloud/run/run-environment.html#environment-variables
variable "TFC_CONFIGURATION_VERSION_GIT_BRANCH" {
  description = "This is the name of the branch that the associated Terraform configuration version was ingressed from (e.g. master)."
  type        = string
}

variable "TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA" {
  description = "This is the full commit hash of the commit that the associated Terraform configuration version was ingressed from (e.g. abcd1234...)."
  type        = string
}

variable "TFC_RUN_ID" {
  description = "This is a unique identifier for this run (e.g. run-CKuwsxMGgMd4W7Ui)."
  type        = string
}

variable "TFC_WORKSPACE_SLUG" {
  description = "String indicating organization and workspace name."
  type        = string
}
