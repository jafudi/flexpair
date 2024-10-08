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
  default     = "flexpair.app" // Registered through dnsimple.com
  description = "A registered domain pointing to rfc2136_name_server."
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid registered domain."
  }
}

resource "dnsimple_record" "gateway_hostname" {
  domain = var.registered_domain
  name   = local.valid_subdomain
  value  = module.gateway_machine.public_ip
  type   = "A"
  ttl    = 60
}

resource "dnsimple_record" "redirect_to_demo" {
  domain = "flexpair.app"
  name   = "demo"
  value  = module.credentials_generator.browser_url
  type   = "URL"
  ttl    = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dnsimple_record.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = local.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}
