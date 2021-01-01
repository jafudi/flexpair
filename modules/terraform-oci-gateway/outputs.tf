output "public_ip" {
  description = ""
  value       = oci_core_instance.gateway.public_ip
}
