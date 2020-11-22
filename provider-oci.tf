// https://registry.terraform.io/providers/hashicorp/oci/latest/docs

provider "oci" {
  region               = var.oci_region
  tenancy_ocid         = var.oci_tenancy_ocid
  user_ocid            = var.oci_user_ocid
  fingerprint          = var.oci_fingerprint
  private_key          = var.oci_private_key
  private_key_password = var.oci_passphrase
}

variable "oci_private_key" {
  type        = string
  description = "Highly sensitive, as credit card could be charged"
}

variable "oci_passphrase" {
  type        = string
  description = "Highly sensitive, as credit card could be charged"
}

variable "oci_tenancy_ocid" {
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaas3oie74wurpodkrygjpztwfscowu3rx42hadgheqrcmesnefllqa"
  description = "Oracle Cloud ID (OCID) of the tenancy"

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.oc1\\.[a-z0-9\\.]+", var.oci_tenancy_ocid))
    error_message = "This does not look like a valid OCID for a tenancy. Please refer to https://jafudi.net/ocid for detailed guidance."
  }
}

variable "oci_user_ocid" {
  type        = string
  default     = "ocid1.user.oc1..aaaaaaaaqfmvke4guehv3ejzc6p2nm4p7gki3o6csth2cqznv62zco76h6aa"
  description = "The user's Oracle Cloud ID (OCID)"

  validation {
    condition     = can(regex("^ocid1\\.user\\.oc1\\.[a-z0-9\\.]+", var.oci_user_ocid))
    error_message = "This does not look like a valid OCID for a user. Please refer to https://jafudi.net/ocid for detailed guidance."
  }
}

variable "oci_region" {
  type        = string
  default     = "eu-frankfurt-1"
  description = "Must be equal to the home region of the tenancy."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-3]$", var.oci_region))
    error_message = "This does not look like a valid Oracle cloud region. Please refer to https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm for detailed guidance."
  }
}

variable "oci_free_tier_avail" {
  type    = number
  default = 2
}

variable "oci_fingerprint" {
  type        = string
  default     = "9c:d0:a4:27:86:77:0e:0c:49:5a:8c:39:4a:a0:c3:ce"
  description = "Fingerprint of the public key"
}