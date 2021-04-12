variable "TFC_WORKSPACE_SLUG" {
  type        = string
  description = "Automatically set string indicating organization and workspace name."
}

variable "registered_domain" {
  type        = string
  default     = "pairpac.com" // Registered through internetwerk.de
  description = "A registered domain pointing to rfc2136_name_server."
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}$", var.registered_domain))
    error_message = "This does not look like a valid registered domain."
  }
}
