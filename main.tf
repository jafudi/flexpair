// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key" {
}

variable "private_key_password" {
}

variable "ssh_public_key" {
}

variable "region" {
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

resource "oci_identity_compartment" "dev_compartment" {
    compartment_id = var.tenancy_ocid
    description = "Named after corresponding Terraform workspace"
    name = terraform.workspace
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_region_mapping[var.region]
}

resource "oci_core_virtual_network" "test_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.dev_compartment.id
  display_name   = "testVCN"
  dns_label      = "testvcn"
}

resource "oci_core_subnet" "gateway_subnet" {
  cidr_block        = "10.1.10.0/24"
  display_name      = "gateway_subnet"
  dns_label         = "gateway-subnet"
  security_list_ids = [oci_core_security_list.test_security_list.id]
  compartment_id    = oci_identity_compartment.dev_compartment.id
  vcn_id            = oci_core_virtual_network.test_vcn.id
  route_table_id    = oci_core_route_table.test_route_table.id
  dhcp_options_id   = oci_core_virtual_network.test_vcn.default_dhcp_options_id
}

resource "oci_core_subnet" "desktop_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "desktop_subnet"
  dns_label         = "desktop-subnet"
  security_list_ids = [oci_core_security_list.test_security_list.id]
  compartment_id    = oci_identity_compartment.dev_compartment.id
  vcn_id            = oci_core_virtual_network.test_vcn.id
  route_table_id    = oci_core_route_table.test_route_table.id
  dhcp_options_id   = oci_core_virtual_network.test_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = oci_identity_compartment.dev_compartment.id
  display_name   = "testIG"
  vcn_id         = oci_core_virtual_network.test_vcn.id
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = oci_identity_compartment.dev_compartment.id
  vcn_id         = oci_core_virtual_network.test_vcn.id
  display_name   = "testRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_security_list" "test_security_list" {
  compartment_id = oci_identity_compartment.dev_compartment.id
  vcn_id         = oci_core_virtual_network.test_vcn.id
  display_name   = "testSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3000"
      min = "3000"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3005"
      min = "3005"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }
}

resource "oci_core_instance" "gateway" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.dev_compartment.id
  display_name        = "gateway"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.gateway_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "gateway"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

resource "oci_core_instance" "desktop" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.dev_compartment.id
  display_name        = "desktop"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "desktop"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

data "oci_core_instance" "gateway" {
    instance_id = oci_core_instance.gateway.id
}

output "gateway" {
  value = "http://${data.oci_core_instance.gateway.public_ip}"
}

