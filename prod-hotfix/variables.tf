variable "guacamole_credentials" {
  description = "Credentials necessary to gain admin access to Guacamole"
  type = object({
    guacamole_endpoint_url   = string
    guacamole_admin_username = string
    guacamole_admin_password = string
  })
}

variable "first_vnc_connection" {
  description = "Credentials for the first desktop's VNC connection"
  type = object({
    title    = string
    hostname = string
    vnc_port = string
    username = string
    password = string
  })
}

variable "gateway_username" {
  description = "UNIX username used for the gateway"
  type        = string
}
