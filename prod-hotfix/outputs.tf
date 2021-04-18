output "user_connections" {
  description = ""
  value       = data.guacamole_user.active_user.connections
}
