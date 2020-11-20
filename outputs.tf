output "used_base_image" {
  value = module.oracle_infrastructure.source_image.display_name
}

locals {
  working_dir = "/Users/jens/PycharmProjects/traction"
}

output "ssh_into_desktop_1" {
  value = "ssh -i ${local.working_dir}/.ssh/privkey -o StrictHostKeyChecking=no ${var.desktop_username}@${module.desktop_machine_1.public_ip}"
}

output "private_key" {
  value = module.shared_secrets.vm_mutual_key.private_key_pem
}

output "gateway_config_size" {
  value = "${length(module.gateway_installer.unencoded_config)} zip to ${length(local.encoded_gateway_config)} / 16384 bytes maximum"
}

output "desktop_config_size" {
  value = "${length(module.desktop_installer.unencoded_config)} zip to ${length(local.encoded_desktop_config)} / 16384 bytes maximum"
}

output "access_url" {
  value = "https://${module.certified_hostname.full_hostname}/?password=${local.murmur_config.password}"
}