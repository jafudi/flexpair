resource "time_sleep" "desktop_rebooted" {
  depends_on      = [module.desktop_1]
  create_duration = "3m"
  triggers = {
    ip_change = module.desktop_1.public_ip
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
    module.gateway,
    time_sleep.dns_propagation,
    module.desktop_1,
    time_sleep.desktop_rebooted
  ]

  # Wait until host is pingable
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "while ! ping -c 1 -w 1 ${local.url.full_hostname} &>/dev/null; do sleep 1; done;"
  }

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --spider --recursive --level 1 https://${local.url.full_hostname}${each.key};"
  }
}