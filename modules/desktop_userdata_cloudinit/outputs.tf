output "unzipped_config" {
  value = data.template_cloudinit_config.desktop_config.rendered
}