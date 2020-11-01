# root module #################################################################

output "compartment" {
  value = "${local.home_region_key}/${local.tenancy_name}/${oci_identity_compartment.one_per_subdomain.name}"
}

# gateway module ##############################################################

# The size of the config is limited to 16384 bytes on most platforms
output "gateway_user_data" {
  value = "${length(base64gzip(data.template_cloudinit_config.gateway_config.rendered))} bytes"
}

output "gateway" {
  value = "${oci_core_instance.gateway.public_ip}, domain = ${local.domain}/?password=${local.murmur_password}"
}

# desktop module ##############################################################

# The size of the config is limited to 16384 bytes on most platforms
output "desktop_config_size" {
  value = "${length(data.template_cloudinit_config.desktop_config.rendered)} bytes"
}

output "desktop" {
  value = "${oci_core_instance.desktop.public_ip} in data center ${data.oci_identity_availability_domain.ad.name}"
}