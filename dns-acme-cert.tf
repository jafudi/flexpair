variable "dns_zone_name" {}

variable "tsig_key_name" {}

variable "tsig_key_secret" {}

# Configure the DNS Provider
provider "dns" {
  update {
    server        = "ns1.dynv6.com"
    key_name      = var.tsig_key_name
    key_algorithm = "hmac-sha512"
    key_secret    = var.tsig_key_secret
  }
}

locals {
    commit_hash = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
    subdomain = lower(local.commit_hash)
    domain = "${local.subdomain}.${var.dns_zone_name}"
}

# Create a DNS A record set
resource "dns_a_record_set" "test_record" {
  zone = "${var.dns_zone_name}."
  name = local.subdomain
  addresses = [ oci_core_instance.gateway.public_ip ]
  ttl = 300
}


/*resource "oci_dns_zone" "test_zone" {
    compartment_id = oci_identity_compartment.client_workspace.id
    name = var.dns_zone_name
    zone_type = "PRIMARY"
}

resource "oci_dns_record" "A_record" {
    compartment_id = oci_dns_zone.test_zone.compartment_id
    zone_name_or_id = var.dns_zone_name
    domain = local.domain
    rtype = "A"
    rdata = oci_core_instance.gateway.public_ip
    ttl = 300
}*/