resource "time_sleep" "gateway_rebooted" {
  depends_on      = [oci_core_instance.gateway]
  create_duration = "300s" # Includes 1m before scheduled shutdown
  triggers = {
    time_created = oci_core_instance.gateway.time_created
  }
}

resource "time_sleep" "desktop_rebooted" {
  depends_on      = [oci_core_instance.desktop]
  create_duration = "300s" # Includes 1m before scheduled shutdown
  triggers = {
    time_created = oci_core_instance.desktop.time_created
  }
}

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
    time_sleep.gateway_rebooted,
    time_sleep.dns_propagation,
    oci_core_instance.desktop,
    time_sleep.desktop_rebooted
  ]

  # Wait until host is pingable
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "while ! ping -c 1 -w 1 ${local.domain} &>/dev/null; do sleep 1; done;"
  }

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --spider --recursive --level 1 https://${local.domain}${each.key};"
  }
}