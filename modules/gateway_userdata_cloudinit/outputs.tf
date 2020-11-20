output "unzipped_config" {
  value = data.template_cloudinit_config.gateway_config.rendered
}
