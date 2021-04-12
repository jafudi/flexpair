locals {
  org_list        = split("/", var.TFC_WORKSPACE_SLUG)
  organization    = org_list[0]
  workspace       = org_list[1]
  valid_subdomain = lower(replace(local.workspace, "/[_\\W]/", "-"))
  full_hostname   = "${local.valid_subdomain}.${var.registered_domain}"
  admin_name      = "${local.organization}admin"
}

provider "guacamole" {
  url                      = "https://${local.full_hostname}/guacamole"
  username                 = local.admin_name
  password                 = "guacadmin"
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
