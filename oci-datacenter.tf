data "oci_identity_tenancy" "te" {
  tenancy_id = var.tenancy_ocid
}

resource "oci_identity_compartment" "one_per_subdomain" {
  compartment_id = var.tenancy_ocid
  description    = "Setting compartment label equal to subdomain label"
  name           = module.certified_hostname.subdomain_label
  freeform_tags  = local.compartment_tags
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.free_tier_available_in
}

locals {
  tenancy_name = data.oci_identity_tenancy.te.name

  compartment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }

  location_info = {
    cloud_region     = var.region
    data_center_name = data.oci_identity_availability_domain.ad.name
    timezone_name    = var.timezone
    locale_settings  = var.locale
  }
}



