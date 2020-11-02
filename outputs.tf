output "compartment" {
  value = "${local.tenancy_name}/${oci_identity_compartment.one_per_subdomain.name}"
}

output "ubuntu-20-04-minimal-latest" {
  value = data.oci_core_images.ubuntu-20-04-minimal.images.0.display_name
}

output "open_in_browser" {
  value = module.gateway.access_url
}