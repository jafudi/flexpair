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
  description = "The contents of the private key file. Highly sensitive, as credit card could be charged."
}

variable "oci_passphrase" {
  type        = string
  description = "Passphrase used for the key, if it is encrypted. Highly sensitive, as credit card could be charged"
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
  description = "An Oracle Cloud Infrastructure region. Must be equal to the home region of the tenancy."

  validation {
    condition = contains([
      "ap-sydney-1",    // Sydney, Australia
      "ap-melbourne-1", // Melbourne, Australia
      "sa-saopaulo-1",  // São Paulo, Brazil
      "ca-montreal-1",  // Montreal, Canada
      "ca-toronto-1",   // Toronto, Canada
      "eu-frankfurt-1", // Frankfurt, Germany
      "ap-hyderabad-1", // Hyderabad, India
      "ap-mumbai-1",    // Mumbai, India
      "ap-osaka-1",     // Osaka, Japan
      "ap-tokyo-1",     // Tokyo, Japan
      "eu-amsterdam-1", // Amsterdam, Netherlands
      "me-jeddah-1",    // Jeddah, Saudi Arabia
      "ap-seoul-1",     // Seoul, South Korea
      "ap-chuncheon-1", // Chuncheon, South Korea
      "eu-zurich-1",    // Zurich, Switzerland
      "uk-london-1",    // London, United Kingdom
      "us-ashburn-1",   // Ashburn, United States
      "us-phoenix-1",   // Phoenix, United States
      "us-sanjose-1"    // San Jose, United States
    ], var.oci_region)
    error_message = "This does not look like a valid Oracle cloud region. Please refer to https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm for detailed guidance."
  }
}

variable "oci_free_tier_avail" {
  description = ""
  type        = number
  default     = 2
}

variable "oci_fingerprint" {
  type        = string
  default     = "9c:d0:a4:27:86:77:0e:0c:49:5a:8c:39:4a:a0:c3:ce"
  description = "Fingerprint of the public key"
}