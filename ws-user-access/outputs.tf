output "access_via_browser" {
  description = ""
  value       = data.terraform_remote_state.main.outputs.access_via_browser
}

output "access_via_mumble" {
  description = ""
  value       = data.terraform_remote_state.main.outputs.access_via_mumble
}
