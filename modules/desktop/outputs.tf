output "public_ip" {
  value = oci_core_instance.desktop.public_ip
}

output "cloud_init_config" {
  value = local.unzipped_config
}

output "cloud_config_size" {
  value = "${length(local.unzipped_config)} zip to ${length(base64gzip(local.unzipped_config))} / 16384 bytes maximum"
}