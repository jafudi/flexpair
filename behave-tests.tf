resource "time_sleep" "desktop_rebooted" {
  depends_on      = [oci_core_instance.desktop]
  create_duration = "300s" # Includes 1m before scheduled shutdown
  triggers = {
    ip_change = oci_core_instance.desktop.public_ip
  }
}

resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/",
    "/desktop-traffic/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    oci_core_instance.gateway,
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