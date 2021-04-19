data "terraform_remote_state" "prod" {
  backend = "remote"
  config = {
    organization = "jafudi"
    workspaces = {
      name = "STAGING"
    }
  }
}

locals {
  gateway_username      = data.terraform_remote_state.prod.outputs.gateway_username
  first_vnc_connection  = data.terraform_remote_state.prod.outputs.first_vnc_credentials
  guacamole_credentials = data.terraform_remote_state.prod.outputs.guacamole_credentials
}
