terraform {
  required_providers {
    guacamole = {
      source  = "techBeck03/guacamole"
      version = "1.2.10" // parameterize together with Guacamole version
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
