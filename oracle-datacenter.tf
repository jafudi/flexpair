// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

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

locals {
  script_dir = "packer-desktop/scripts"
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key      = var.private_key
  private_key_password = var.private_key_password
}

variable "ad_region_mapping" {
  type = map(string)

  default = {
    # The only availability domain in Frankfurt which allows for creating Micro instance
    # This could change over time!!!
    eu-frankfurt-1 = 2
  }
}

variable "images" {
  type = map(string)

  default = {
    # Canonical-Ubuntu-20.04-Minimal-2020.09.07-0
    # Updates: https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-2004/
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaarlmgtd4s7adtcuxi3dbri34kb5lcommgbmf5ywrggymccjvqv6gq"
  }
}

resource "oci_identity_compartment" "client_workspace" {
    compartment_id = var.tenancy_ocid
    description = "Named after corresponding Terraform workspace"
    name = terraform.workspace
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_region_mapping[var.region]
}
