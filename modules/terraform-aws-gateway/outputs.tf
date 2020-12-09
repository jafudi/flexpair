output "public_ip" {
  description = ""
  value       = aws_instance.gateway.public_ip
}
