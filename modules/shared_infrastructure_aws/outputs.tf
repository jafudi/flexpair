output "cloud_account_name" {
  value = "aws_account_${data.aws_caller_identity.current.account_id}"
}

output "vm_instance_context" {
  value = {
    vpc_id                   = aws_vpc.main.id
    subnet_id                = aws_subnet.public_subnet.id
    shared_security_group_id = aws_security_group.basic.id
    source_image_id          = data.aws_ami.latest-ubuntu-focal.id
    minimum_viable_shape     = "t2.micro"
  }
}

output "source_image_name" {
  value = data.aws_ami.latest-ubuntu-focal.description
}