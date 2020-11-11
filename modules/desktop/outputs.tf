output "public_ip" {
  value = oci_core_instance.desktop.public_ip
}

output "encoded_config" {
  value = local.encoded_config
}

output "encoded_config_size" {
  value = "${length(local.encoded_config)} / 16384 bytes maximum"
}