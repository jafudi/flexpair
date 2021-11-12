locals {
  docker_compose_release = "1.28.6"
  mumbling_mole_version  = "1.3.3"
}

terraform {
  required_providers {
    guacamole = {
      source  = "techBeck03/guacamole"
      version = "1.2.0" // parameterize together with Guacamole version
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
