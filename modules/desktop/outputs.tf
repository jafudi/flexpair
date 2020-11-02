# The size of the config is limited to 16384 bytes on most platforms
output "userdata_bytes" {
  value = length(base64gzip(data.template_cloudinit_config.desktop_config.rendered))
}

output "public_ip" {
  value = oci_core_instance.desktop.public_ip
}