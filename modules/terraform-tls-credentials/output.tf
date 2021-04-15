output "vm_mutual_key" {
  description = ""
  value       = tls_private_key.vm_mutual_key
  sensitive   = true
}

output "vnc_port" {
  description = "Randomly chosen VNC port increases security"
  value       = random_integer.vnc_port.result
}

output "email_config" {
  description = ""
  value       = local.email_config
  sensitive   = true
}

output "murmur_credentials" {
  description = ""
  value       = local.murmur_credentials
  sensitive   = true
}

output "gateway_username" {
  description = "Make sure the first character is a lower case roman letter"
  value       = replace(var.gateway_cloud_info.cloud_account_name, "/^([^a-z])/", "u$1")
}

output "desktop_username" {
  description = "Making sure the first character is a lower case roman letter"
  value       = replace(var.desktop_cloud_info.cloud_account_name, "/^([^a-z])/", "u$1")
}

output "gateway_primary_nic_name" {
  description = ""
  value       = var.gateway_cloud_info.network_interface_name
}

output "desktop_primary_nic_name" {
  description = ""
  value       = var.desktop_cloud_info.network_interface_name
}

output "letsencrypt_certificate" {
  description = ""
  value       = acme_certificate.letsencrypt_certificate
  sensitive   = true
}

output "browser_url" {
  description = ""
  value       = "https://${var.full_hostname}/?password=${urlencode(local.murmur_credentials.password)}"
}

output "mumble_url" {
  description = ""
  value       = "mumble://:${urlencode(local.murmur_credentials.password)}@${var.full_hostname}:${local.murmur_credentials.port}"
}
