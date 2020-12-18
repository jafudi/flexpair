output "unzipped_config" {
  description = ""
  value       = data.template_cloudinit_config.desktop_config.rendered
}