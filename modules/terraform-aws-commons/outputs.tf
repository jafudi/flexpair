output "additional_metadata" {
  value = {
    cloud_provider_name    = "aws"
    cloud_account_name     = data.aws_caller_identity.current.account_id
    source_image_info      = data.aws_ami.latest-ubuntu-focal.description
    network_interface_name = "eth0"
  }
}

output "vm_creation_context" {
  value = {
    vpc_id                   = aws_vpc.main.id
    subnet_id                = aws_subnet.public_subnet.id
    shared_security_group_id = aws_security_group.basic.id
    source_image_id          = data.aws_ami.latest-ubuntu-focal.id
    minimum_viable_shape     = "t2.micro"
  }
}
