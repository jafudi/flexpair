provider "dnsimple" {
  token   = var.dnsimple_account_token
  account = var.dnsimple_account_id
}

variable "dnsimple_account_id" {
  description = ""
  type        = number
}

variable "dnsimple_account_token" {
  description = ""
  type        = string
}

provider "acme" {
  # 50 certificates per registered domain per week
  # as per https://letsencrypt.org/docs/rate-limits/
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "registered_domain" {
  type        = string
  default     = "flexpair.com" // Registered through dnsimple.com
  description = "A registered domain pointing to rfc2136_name_server."
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid registered domain."
  }
}


resource "dnsimple_zone_record" "redirect_to_demo" {
  zone_name = var.registered_domain
  name      = "demo"
  value     = "${local.valid_subdomain}.${var.registered_domain}"
  type      = "CNAME"
  ttl       = 60
}

resource "dnsimple_zone_record" "add_credentials" {
  zone_name = var.registered_domain
  name      = local.valid_subdomain
  value     = "${module.credentials_generator.browser_url}&username=guest"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "gateway_hostname" {
  zone_name = var.registered_domain
  name      = local.valid_subdomain
  value     = module.gateway_machine.public_ip
  type      = "A"
  ttl       = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dnsimple_zone_record.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = local.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}
