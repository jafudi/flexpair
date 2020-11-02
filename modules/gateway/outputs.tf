# The size of the config is limited to 16384 bytes on most platforms
output "userdata_bytes" {
  value = length(base64gzip(data.template_cloudinit_config.gateway_config.rendered))
}

output "public_ip" {
  value = oci_core_instance.gateway.public_ip
}

output "access_url" {
  value = "${var.url.proto_scheme}${var.url.full_hostname}/?password=${var.murmur_config.password}"
}