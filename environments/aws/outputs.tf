output "desktop_base_image" {
  description = ""
  value       = local.desktop_additional_info.source_image_info
}

output "gateway_base_image" {
  description = ""
  value       = local.gateway_additional_info.source_image_info
}

output "gateway_ip" {
  description = ""
  value       = module.gateway_machine.public_ip
}

output "private_key" {
  description = ""
  value       = module.credentials_generator.vm_mutual_key.private_key_pem
  sensitive   = true
}

output "gateway_config_size" {
  description = ""
  value       = "${local.unzipped_gateway_bytes} base64gzip to ${length(local.encoded_gateway_config)} / 16384 bytes maximum"
}

output "desktop_config_size" {
  description = ""
  value       = "${local.unzipped_desktop_bytes} base64gzip to ${length(local.encoded_desktop_config)} / 16384 bytes maximum"
}

output "access_via_browser" {
  description = ""
  value       = nonsensitive(module.credentials_generator.browser_url)
  # We want this to be displayed on the overview page for logged in users
}

output "access_via_mumble" {
  description = ""
  value       = nonsensitive(module.credentials_generator.mumble_url)
  # We want this to be displayed on the overview page for logged in users
}

output "murmur_password" {
  description = ""
  value       = module.credentials_generator.murmur_credentials.password
  sensitive   = true
}

# Below outputs are used to configure Guacamole from a separate workspace

output "gateway_username" {
  description = "UNIX username used for the gateway"
  value       = module.credentials_generator.gateway_username
  sensitive   = true
}

output "guacamole_credentials" {
  description = "Credentials necessary to gain admin access to Guacamole"
  value       = module.credentials_generator.guacamole_credentials
  sensitive   = true
}

output "first_vnc_credentials" {
  description = "Credentials for the first desktop's VNC connection"
  value       = module.credentials_generator.vnc_credentials
  sensitive   = true
}

// REMOVE LATER BECAUSE UNSAFE, ONLY FOR DEBUGGING
output "first_vnc_hostname" {
  value       = nonsensitive(module.credentials_generator.vnc_credentials.hostname)
}

output "first_vnc_port" {
  value       = nonsensitive(module.credentials_generator.vnc_credentials.vnc_port)
}

output "first_vnc_username" {
  value       = nonsensitive(module.credentials_generator.vnc_credentials.username)
}

output "first_vnc_password" {
  value       = nonsensitive(module.credentials_generator.vnc_credentials.password)
}

output "ssh_config" {
  description = "For appending to your local SSH config file"
  value       = <<-EOT
  Host Gateway
    HostName ${local.full_hostname}
    StrictHostKeyChecking no
    User ${module.credentials_generator.desktop_username}

  Host Desktop_1
    ProxyJump Gateway
    HostName ${module.desktop_machine_1.public_ip}
    StrictHostKeyChecking no
    User ${module.credentials_generator.gateway_username}
  EOT
}
