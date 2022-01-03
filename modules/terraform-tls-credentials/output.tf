output "vm_mutual_key" {
  description = ""
  value       = tls_private_key.vm_mutual_key
  sensitive   = true
}

output "vnc_credentials" {
  description = "Randomly chosen VNC port increases security"
  value       = local.first_vnc_crendentials
  sensitive   = true
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

output "guacamole_credentials" {
  description = ""
  value       = local.guacamole_credentials
  sensitive   = true
}

output "gateway_username" {
  description = "Make sure the first character is a lower case roman letter"
  value       = replace(var.gateway_cloud_account, "/^([^a-z])/", "u$1")
}

output "desktop_username" {
  description = "Making sure the first character is a lower case roman letter"
  value       = replace(var.desktop_cloud_account, "/^([^a-z])/", "u$1")
}

output "letsencrypt_certificate" {
  description = ""
  value       = acme_certificate.letsencrypt_certificate
  sensitive   = true
}

output "browser_url" {
  description = ""
  value       = "https://${var.full_hostname}/?password=${urlencode(local.murmur_credentials.password)}"
  sensitive   = true
}

output "mumble_url" {
  description = ""
  value       = "mumble://:${urlencode(local.murmur_credentials.password)}@${var.full_hostname}:${local.murmur_credentials.port}"
  sensitive   = true
}

output "guest_username" {
  description = "Could be randomized in the future."
  value       = "valued_guest"
  sensitive   = true
}
