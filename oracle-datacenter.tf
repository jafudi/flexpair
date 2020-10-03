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

    # European Union
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaarlmgtd4s7adtcuxi3dbri34kb5lcommgbmf5ywrggymccjvqv6gq"
    eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaag4xqrawt3mwlfomh3erv5efruhrezmb7asjzgttwsqbgcnaswu7a"
    eu-zurich-1	= "ocid1.image.oc1.eu-zurich-1.aaaaaaaad4ub4lk5v6mvewr4hzyklb2wg3r65hg5lsf3qukffkobwcmcf4zq"

    # Saudi Arabia
    me-jeddah-1	= "ocid1.image.oc1.me-jeddah-1.aaaaaaaagqbjyuznyfqcvlvufxi23cxwxl7bmpip5f2acgx37u4jrzjjojbq"

    # India
    ap-hyderabad-1 = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaanasey7lchyzpysuy7ewhcl62szbxl6ukl6f3oiftmg5icd63mgxq"
    ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaf2ctw6opzdyumqn2a662msdxpofazsmrlwpew26ndounnwecl2gq"

    # South Korea
    ap-chuncheon-1 = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaa4exqoxhpjed6xtm4skfehykdqkpwhaac6aueswt6lqofy5ssxqjq"
    ap-seoul-1 = "ocid1.image.oc1.ap-seoul-1.aaaaaaaarqe7w245wfkhizcr352yd6a73knddgapxrjtsyyl4rq3iwx4b5iq"

    # Japan
    ap-osaka-1 = "ocid1.image.oc1.ap-osaka-1.aaaaaaaaevxg6tpchgyijcdjlzcflkat5ndpsfy6n3tjois2qe3yrtrjrnlq"
    ap-tokyo-1 = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaa2lb55favhw7mhirylv4pniqu3oxpmoyjbrtfank4kdleiflfqbta"

    # Australia
    ap-melbourne-1 = "ocid1.image.oc1.ap-melbourne-1.aaaaaaaa7prwq4xmmmqmkb23dmcuyaa6ugn4gosn37gvhcyprtpulqx5m4zq"
    ap-sydney-1 = "ocid1.image.oc1.ap-sydney-1.aaaaaaaa7wfrxwdv5tc3rne2e6hk3dbl4lxrcktm74hp6spkjukwqjea2qiq"

    # Canada
    ca-montreal-1 = "ocid1.image.oc1.ca-montreal-1.aaaaaaaa32g3ojwo3fkiejozj4fnvehshafy5m2bsywbwowu2l4l4ms42zjq"
    ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaoug2iqgnuvzv7cbxsdvezbcivfde44wn5ojhwmj7sfct5pp2wxga"

    # United States
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaaffttreqvrrvnn5yj57jdqdcl4dhxuin543fb3debmbmgk7n4bf2a"
    us-langley-1 = "ocid1.image.oc2.us-langley-1.aaaaaaaadr3ahvhb2bw427ukvz7iw6hvuzqh3o657fjqdw4fqmjidds7ds5q"
    us-luke-1 = "ocid1.image.oc2.us-luke-1.aaaaaaaajv3zon3mvr5gp2d7qz6f4ea62jyisgglzammyf5tooghwyh4m7wq"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaizxszm6byd2azc5hz5hfxx7gr3r4f5v3inm2ukopzr5juvpslofa"
    us-sanjose-1 = "ocid1.image.oc1.us-sanjose-1.aaaaaaaaldq7nqiaf7jwojhudbsfgyqprmg576ddgns3b3comrkrkstblooq"

    # Brazil
    sa-saopaulo-1 = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaask7nuuvtwxmmgmg2tgahlurbbqwohc4tnfiwxdzifo7iwdwjslna"

    # United Kingdom
    uk-london-1	= "ocid1.image.oc1.uk-london-1.aaaaaaaasjs2ybnm22vx5ui7cklmnlobmweslpryhyvkjpiouchgtilpeypa"
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
