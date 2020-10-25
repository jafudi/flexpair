resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/",
    "/gateway-traffic/",
    "/desktop-traffic/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    oci_core_instance.gateway,
    time_sleep.gateway_rebooting_now,
    time_sleep.dns_propagation,
    oci_core_instance.desktop,
    time_sleep.desktop_rebooting_now
  ]

  # Wait until host is pingable
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "while ! ping -c 1 -w 1 ${local.domain} &>/dev/null; do sleep 1; done;"
  }

  # Give nginx time to come up and then test HTTPS endpoint
  provisioner "local-exec" {
    environment = {
      EXPECTIDLE = 300
    }
    interpreter = ["/bin/bash", "-c"]
    command     = "sleep $EXPECTIDLE; wget --spider --recursive --level 1 https://${local.domain}${each.key};"
  }
}