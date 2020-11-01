# root module #################################################################

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

variable "murmur_port" {}

variable "mailbox_prefix" {}

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

# gateway module ##############################################################

variable "gateway_shape" {}

# desktop module ##############################################################

variable "desktop_shape" {}

variable "gitlab_runner_token" {}