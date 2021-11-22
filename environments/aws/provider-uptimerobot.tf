provider "uptimerobot" {
  api_key = var.uptimerobot_api_key
}

resource "uptimerobot_monitor" "demo_mumble_web" {
  friendly_name = "Flexpair Demo: Does mumble-web load?"
  type          = "http"
  url           = local.full_hostname
}

resource "uptimerobot_monitor" "demo_murmur_server" {
  friendly_name = "Flexpair Demo: Is murmur server up?"
  type          = "port"
  sub_type      = "custom"
  url           = local.full_hostname
  port          = module.credentials_generator.murmur_credentials.port
}
