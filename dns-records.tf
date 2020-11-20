# Configure the DNS Provider
provider "dns" {
  update {
    server        = var.rfc2136_name_server
    key_name      = var.rfc2136_key_name
    key_algorithm = var.rfc2136_tsig_algorithm
    key_secret    = var.rfc2136_key_secret
  }
}

# Create a DNS A record set
resource "dns_a_record_set" "gateway_hostname" {
  zone      = "${var.registered_domain}."
  name      = module.certified_hostname.subdomain_label
  addresses = [module.gateway_machine.public_ip]
  ttl       = 60
}

resource "time_sleep" "dns_propagation" {
  depends_on      = [dns_a_record_set.gateway_hostname]
  create_duration = "120s"
  triggers = {
    map_from = module.certified_hostname.full_hostname
    map_to   = module.gateway_machine.public_ip
  }
}
