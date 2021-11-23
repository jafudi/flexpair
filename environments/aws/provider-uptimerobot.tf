variable "uptimerobot_api_key" {
  description = ""
  type        = string
}

provider "uptimerobot" {
  api_key = var.uptimerobot_api_key
}

resource "uptimerobot_monitor" "demo_mumble_web" {
  friendly_name = "mumble webapp of Flexpair demo"
  type          = "http"
  url           = module.credentials_generator.browser_url
}

resource "uptimerobot_monitor" "demo_guacamole" {
  friendly_name = "mumble webapp of Flexpair demo"
  type          = "http"
  url           = "https://${local.full_hostname}/guacamole/"
}

resource "uptimerobot_monitor" "demo_murmur_server" {
  friendly_name = "mumble server of Flexpair demo"
  type          = "port"
  sub_type      = "custom"
  url           = local.full_hostname
  port          = module.credentials_generator.murmur_credentials.port
}

resource "uptimerobot_monitor" "demo_imap_server" {
  friendly_name = "email server of Flexpair demo"
  type          = "port"
  sub_type      = "imap"
  url           = local.full_hostname
}
