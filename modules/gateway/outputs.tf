output "cloud_init_config" {
  value = local.unzipped_config
}

output "cloud_config_size" {
  value = "${length(local.unzipped_config)} zip to ${length(base64gzip(local.unzipped_config))} / 16384 bytes maximum"
}

output "public_ip" {
  value = oci_core_instance.gateway.public_ip
}

output "access_url" {
  value = "${var.url.proto_scheme}${var.url.full_hostname}/?password=${var.murmur_config.password}"
}