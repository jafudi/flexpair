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
    condition     = can(regex("^ocid1\\.user\\.oc1\\.[a-z0-9\\.]+", var.user_ocid))
    error_message = "This does not look like a valid OCID for a user. Please refer to https://jafudi.net/ocid for detailed guidance."
  }
}

variable "region" {
  type        = string
  description = "Must be equal to the home region of the tenancy."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-3]$", var.region))
    error_message = "This does not look like a valid Oracle cloud region. Please refer to https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm for detailed guidance."
  }
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
