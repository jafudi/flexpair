variable "tenancy_ocid" {
  type        = string
  description = "Oracle Cloud ID (OCID) of the tenancy"
}

variable "user_ocid" {
  type        = string
  description = "The user's Oracle Cloud ID (OCID)"
}

variable "region" {
  type        = string
  description = "Must be equal to the home region of the tenancy."
}

variable "deployment_tags" {
  type = map(string)
}

variable "compartment_name" {
  type = string
}

variable "availibility_domain_number" {
  type = number
}
