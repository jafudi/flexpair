output "used_base_image" {
  value = module.oracle_infrastructure.source_image_name
}

output "email_adress" {
  value = module.credentials_generator.email_config.address
}

output "ssh_into_desktop_1" {
  value = "ssh -i ${path.root}/.ssh/privkey -o StrictHostKeyChecking=no ${module.credentials_generator.desktop_username}@${module.desktop_machine_1.public_ip}"
}

output "private_key" {
  value = module.credentials_generator.vm_mutual_key.private_key_pem
}

output "gateway_config_size" {
  value = "${local.unzipped_gateway_bytes} base64gzip to ${length(local.encoded_gateway_config)} / 16384 bytes maximum"
}

output "desktop_config_size" {
  value = "${local.unzipped_desktop_bytes} base64gzip to ${length(local.encoded_desktop_config)} / 16384 bytes maximum"
}

output "access_via_browser" {
  value = "https://${module.credentials_generator.full_hostname}/?password=${urlencode(module.credentials_generator.murmur_credentials.password)}"
}

output "access_via_mumble" {
  value = "mumble://:${urlencode(module.credentials_generator.murmur_credentials.password)}@${module.credentials_generator.full_hostname}:${module.credentials_generator.murmur_credentials.port}"
}