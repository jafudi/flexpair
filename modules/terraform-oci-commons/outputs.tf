output "additional_metadata" {
  value = {
    cloud_account_name     = data.oci_identity_tenancy.te.name
    source_image_info      = data.oci_core_images.ubuntu-20-04-minimal.images.0.display_name
    network_interface_name = "ens3"
  }
}

output "vm_creation_context" {
  value = {
    vcn_id                   = oci_core_virtual_network.main_vcn.id
    route_table_id           = oci_core_route_table.common_route_table.id
    dhcp_options_id          = oci_core_virtual_network.main_vcn.default_dhcp_options_id
    security_list_id         = oci_core_security_list.shared_security_list.id
    availability_domain_name = data.oci_identity_availability_domain.ad.name
    compartment_id           = oci_identity_compartment.one_per_subdomain.id
    source_image_id          = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
    minimum_viable_shape     = "VM.Standard.E2.1"
  }
}
