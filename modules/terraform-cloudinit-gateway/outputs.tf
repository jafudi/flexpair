output "unzipped_config" {
  description = ""
  value       = data.template_cloudinit_config.gateway_config.rendered
}
