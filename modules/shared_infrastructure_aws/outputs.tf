//output "network_config" {
//  value = {
//    vcn_id = oci_core_virtual_network.main_vcn.id
//    route_table_id = oci_core_route_table.common_route_table.id
//    dhcp_options_id = oci_core_virtual_network.main_vcn.default_dhcp_options_id
//    security_list_id = oci_core_security_list.shared_security_list.id
//  }
//}
//
//output "tenancy_name" {
//  value = data.oci_identity_tenancy.te.name
//}
//
//output "compartment" {
//  value = oci_identity_compartment.one_per_subdomain
//}

output "source_image" {
  value = data.aws_ami.latest-ubuntu-focal
}

//output "availability_domain_name" {
//  value = data.oci_identity_availability_domain.ad.name
//}

output "minimum_viable_shape" {
  value = "t2.micro"
}