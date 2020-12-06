output "vm_mutual_key" {
  value = tls_private_key.vm_mutual_key
}

output "email_config" {
  value = local.email_config
}

output "murmur_credentials" {
  value = local.murmur_credentials
}

output "gateway_username" {
  value = "${var.gateway_cloud_info.cloud_provider_name}_${var.gateway_cloud_info.cloud_account_name}"
}

output "desktop_username" {
  value = "${var.desktop_cloud_info.cloud_provider_name}_${var.desktop_cloud_info.cloud_account_name}"
}

output "gateway_primary_nic_name" {
  value = var.gateway_cloud_info.network_interface_name
}

output "desktop_primary_nic_name" {
  value = var.desktop_cloud_info.network_interface_name
}

output "subdomain_label" {
  value = local.valid_subdomain
}

output "full_hostname" {
  value = local.full_hostname
}

output "letsencrypt_certificate" {
  value = acme_certificate.letsencrypt_certificate
}