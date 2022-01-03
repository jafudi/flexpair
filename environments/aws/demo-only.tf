variable "demo_subdomain" {
  description = "the demo in demo.flexpair.com"
  type        = string
  default     = ""
}

locals {
  is_public_demo = (var.TFC_CONFIGURATION_VERSION_GIT_BRANCH == "master") && (length(var.demo_subdomain) > 0) ? true : false
  demo_hostname  = local.is_public_demo ? "${var.demo_subdomain}.${var.registered_domain}" : null
}

resource "dnsimple_zone_record" "demo_hostname" {
  count     = local.is_public_demo ? 1 : 0
  zone_name = var.registered_domain
  name      = var.demo_subdomain
  value     = local.full_hostname
  type      = "CNAME"
  ttl       = 60
}

variable "uptimerobot_api_key" {
  description = ""
  type        = string
}

provider "uptimerobot" {
  api_key = var.uptimerobot_api_key
}


resource "uptimerobot_monitor" "link_to_demo" {
  count         = local.is_public_demo ? 1 : 0
  friendly_name = "DNS record of Flexpair demo"
  type          = "ping"
  url           = "https://${local.demo_hostname}"
}

resource "uptimerobot_monitor" "desktop_vm" {
  count         = local.is_public_demo ? 1 : 0
  friendly_name = "desktop VM of Flexpair demo"
  type          = "ping"
  url           = module.desktop_machine_1.public_ip
}

resource "uptimerobot_monitor" "web_frontend" {
  count         = local.is_public_demo ? 1 : 0
  friendly_name = "mumble webapp of Flexpair demo"
  type          = "http"
  url           = module.credentials_generator.browser_url
}

resource "uptimerobot_monitor" "guacamole_app" {
  count         = local.is_public_demo ? 1 : 0
  friendly_name = "guacamole app of Flexpair demo"
  type          = "http"
  url           = "https://${local.full_hostname}/guacamole/"
}

resource "uptimerobot_monitor" "mumble_server" {
  friendly_name = "mumble server of Flexpair demo"
  count         = local.is_public_demo ? 1 : 0
  type          = "port"
  sub_type      = "custom"
  url           = local.full_hostname
  port          = module.credentials_generator.murmur_credentials.port
}

resource "uptimerobot_monitor" "imap_server" {
  count         = local.is_public_demo ? 1 : 0
  friendly_name = "email server of Flexpair demo"
  type          = "port"
  sub_type      = "smtp"
  url           = local.full_hostname
}
