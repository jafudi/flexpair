output "network_config" {
  value = {
    vpc_id                   = aws_vpc.main.id
    subnet_id                = aws_subnet.public_subnet.id
    shared_security_group_id = aws_security_group.basic.id
  }
}

output "source_image" {
  value = data.aws_ami.latest-ubuntu-focal
}

output "minimum_viable_shape" {
  value = "t2.micro"
}

output "account_name" {
  value = "aws_account_${data.aws_caller_identity.current.account_id}"
}