data "terraform_remote_state" "prod" {
  backend = "remote"
  config = {
    organization = "jafudi"
    workspaces = {
      name = "STAGING"
    }
  }
}

provider "guacamole" {
  url                      = data.terraform_remote_state.prod.outputs.guacamole_endpoint
  username                 = data.terraform_remote_state.prod.outputs.guacamole_admin_username
  password                 = data.terraform_remote_state.prod.outputs.guacamole_admin_password
  disable_tls_verification = true
  disable_cookies          = true
}

resource "guacamole_connection_vnc" "collaborate" {
  name              = "Collaborate: ${var.first_vnc_connection.title}"
  parent_identifier = "ROOT"
  attributes {
    failover_only = false
  }
  parameters {
    hostname            = var.first_vnc_connection.hostname
    port                = var.first_vnc_connection.vnc_port
    username            = var.first_vnc_connection.username
    password            = var.first_vnc_connection.password
    sftp_hostname       = var.first_vnc_connection.hostname
    sftp_username       = var.gateway_username
    sftp_directory      = "/home/${var.gateway_username}/uploads"
    sftp_root_directory = "/home/${var.gateway_username}/uploads"
    readonly            = false
    enable_audio        = false
    enable_sftp         = true
    disable_copy        = false
    disable_paste       = false
  }
}

resource "guacamole_connection_vnc" "view_only" {
  name              = "View only: ${var.first_vnc_connection.title}"
  parent_identifier = "ROOT"
  attributes {
    failover_only = false
  }
  parameters {
    hostname            = var.first_vnc_connection.hostname
    port                = var.first_vnc_connection.vnc_port
    username            = var.first_vnc_connection.username
    password            = var.first_vnc_connection.password
    sftp_hostname       = var.first_vnc_connection.hostname
    sftp_username       = var.gateway_username
    sftp_directory      = "/home/${var.gateway_username}/uploads"
    sftp_root_directory = "/home/${var.gateway_username}/uploads"
    readonly            = true
    enable_audio        = false
    enable_sftp         = false
    disable_copy        = true
    disable_paste       = true
  }
}

resource "guacamole_connection_ssh" "admin_console" {
  name              = "Administrate: Gateway Terminal"
  parent_identifier = "ROOT"
  attributes {
    failover_only = false
  }
  parameters {
    hostname            = "gateway"
    port                = 22
    username            = var.gateway_username
    sftp_root_directory = "/home/${var.gateway_username}/uploads"
    readonly            = false
    enable_sftp         = true
    color_scheme        = "green-black"
  }
}
