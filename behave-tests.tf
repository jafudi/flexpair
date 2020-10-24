locals {
  hostname = "${local.subdomain}.${var.registered_domain}"
  check_locations = toset([
    "/",
    "/guacamole/",
    "/gateway-traffic/",
    "/desktop-traffic/"
  ])
}

resource "null_resource" "health_check" {

  for_each = local.check_locations

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    oci_core_instance.gateway,
    dns_a_record_set.gateway_hostname,
    oci_core_instance.desktop
  ]

  provisioner "local-exec" {
    environment = {
      WAIT  = 5
      CHECK = "wget --spider"
      URL   = "https://${local.domain}${each.key}"
    }
    interpreter = ["/bin/bash", "-c"]
    command     = "sleep $WAIT; $CHECK $URL; [[ $? == '0' ]] || exit 1;"
  }
}