provider "guacamole" {
  url                      = local.guacamole_credentials.guacamole_endpoint_url
  username                 = local.guacamole_credentials.guacamole_admin_username
  password                 = local.guacamole_credentials.guacamole_admin_password
  disable_tls_verification = true
  disable_cookies          = true
}

resource "guacamole_connection_vnc" "collaborate" {
  name              = "Collaborate: ${local.first_vnc_connection.title}"
  parent_identifier = "ROOT"
  attributes {
    failover_only = false
  }
  parameters {
    hostname              = local.first_vnc_connection.hostname
    port                  = local.first_vnc_connection.vnc_port
    username              = local.first_vnc_connection.username
    password              = local.first_vnc_connection.password
    sftp_enable           = true
    sftp_hostname         = "gateway"
    sftp_username         = local.gateway_username
    sftp_upload_directory = "/home/${local.gateway_username}/uploads"
    sftp_root_directory   = "/home/${local.gateway_username}/uploads"
    readonly              = false
    enable_audio          = false
    disable_copy          = false
    disable_paste         = false
  }
}

resource "guacamole_connection_vnc" "view_only" {
  name              = "View only: ${local.first_vnc_connection.title}"
  parent_identifier = "ROOT"
  attributes {
    failover_only = false
  }
  parameters {
    hostname              = local.first_vnc_connection.hostname
    port                  = local.first_vnc_connection.vnc_port
    username              = local.first_vnc_connection.username
    password              = local.first_vnc_connection.password
    sftp_enable           = false
    sftp_hostname         = "gateway"
    sftp_username         = local.gateway_username
    sftp_upload_directory = "/home/${local.gateway_username}/uploads"
    sftp_root_directory   = "/home/${local.gateway_username}/uploads"
    readonly              = true
    enable_audio          = false
    disable_copy          = true
    disable_paste         = true
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
    username            = local.gateway_username
    sftp_root_directory = "/home/${local.gateway_username}/uploads"
    readonly            = false
    sftp_enable         = true
    color_scheme        = "green-black"
  }
}

resource "guacamole_user" "activeUser" {
  username = "active"

  attributes {
    full_name = "Test User"
    email     = "testUser@example.com"
    timezone  = "America/Chicago"
  }
}
