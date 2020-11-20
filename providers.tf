provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "oci" {
  region               = var.region
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key          = var.private_key
  private_key_password = var.private_key_password
}