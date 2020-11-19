# Configure the DNS Provider
provider "dns" {
  update {
    server        = var.rfc2136_name_server
    key_name      = var.rfc2136_key_name
    key_algorithm = var.rfc2136_tsig_algorithm
    key_secret    = var.rfc2136_key_secret
  }
}

locals {
  compound_name = "${var.TFC_CONFIGURATION_VERSION_GIT_BRANCH}-branch-${var.TFC_WORKSPACE_NAME}"
  valid_subdomain = lower(replace(local.compound_name,"/[_\\W]/","-"))

  url = {
    proto_scheme      = "https://"
    subdomain_label   = local.valid_subdomain
    registered_domain = var.registered_domain
    toplevel_domain   = reverse(split(".", var.registered_domain))[0]
    full_hostname     = "${local.valid_subdomain}.${var.registered_domain}"
  }
}

# Create a DNS A record set
resource "dns_a_record_set" "gateway_hostname" {
  zone      = "${var.registered_domain}."
  name      = local.url.subdomain_label
  addresses = [module.gateway_machine.public_ip]
  ttl       = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dns_a_record_set.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = local.url.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}
