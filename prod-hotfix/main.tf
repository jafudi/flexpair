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

resource "guacamole_user" "user" {

  username = "testGuacamoleUser"
  attributes {
    full_name = "Test User"
    email     = "testUser@example.com"
    timezone  = "America/Chicago"
  }
  system_permissions = ["ADMINISTER", "CREATE_USER"]
}

data "guacamole_user" "user" {
  username = "active"
}
