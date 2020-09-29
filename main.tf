// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "region" {
}

variable "compartment" {
}

variable "private_key" {
}

variable "fingerprint" {
}

variable "private_key_password" {
}

variable "vm_public_key" {
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
    # Oracle-provided image "Ubuntu 20.04 minimal"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaukhdqqokh3evzyqvashnxld2gyl2wx6k5cratnb7hcxij4u7eh3q"
  }
}

resource "oci_identity_compartment" "client_workspace" {
    compartment_id = var.tenancy_ocid
    description = "Named after corresponding Terraform workspace"
    name = var.compartment
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_region_mapping[var.region]
}

resource "oci_core_virtual_network" "main_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.client_workspace.id
  display_name   = "Main Virtual Cloud Network"
  dns_label      = "mainvcn"
}

resource "oci_core_internet_gateway" "common_internet_gateway" {
  compartment_id = oci_identity_compartment.client_workspace.id
  display_name   = "Common Internet Gateway"
  vcn_id         = oci_core_virtual_network.main_vcn.id
}

resource "oci_core_route_table" "common_route_table" {
  compartment_id = oci_identity_compartment.client_workspace.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Common Route Table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.common_internet_gateway.id
  }
}

