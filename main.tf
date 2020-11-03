module "gateway" {
  source = "./modules/gateway"
  depends_on = [
    # Continue only after certificate was successfully issued
    acme_certificate.letsencrypt_certificate
  ]
  compartment    = oci_identity_compartment.one_per_subdomain
  location_info  = local.location_info
  network_config = local.network_config
  vm_specs = {
    compute_shape   = var.gateway_shape
    source_image_id = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
  }
  vm_mutual_keypair      = tls_private_key.vm_mutual_key
  gateway_username     = var.gateway_username
  desktop_username      = var.desktop_username
  ssl_certificate        = acme_certificate.letsencrypt_certificate
  murmur_config          = local.murmur_config
  url                    = local.url
  email_config           = local.email_config
  docker_compose_release = local.docker_compose_release
}

resource "tls_private_key" "vm_mutual_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

module "desktop_1" {
  source = "./modules/desktop"
  depends_on = [
    # Continue only after certificate was successfully issued
    acme_certificate.letsencrypt_certificate
  ]
  compartment    = oci_identity_compartment.one_per_subdomain
  location_info  = local.location_info
  network_config = local.network_config
  vm_specs = {
    compute_shape   = var.desktop_shape
    source_image_id = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
  }
  vm_mutual_keypair   = tls_private_key.vm_mutual_key
  gateway_username     = var.gateway_username
  desktop_username      = var.desktop_username
  murmur_config       = local.murmur_config
  email_config        = local.email_config
  url                 = local.url
  gitlab_runner_token = "JW6YYWLG4mTsr_-mSaz8"
}