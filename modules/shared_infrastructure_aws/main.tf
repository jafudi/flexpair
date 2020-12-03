data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default" // Using either of the other options costs at least $2/hr!!

  tags = merge(var.deployment_tags, {
    Name = "Main Private Cloud"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.deployment_tags, {
    Name = "Common Internet Gateway"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.10.0/24"
  map_public_ip_on_launch = true

  tags = merge(var.deployment_tags, {
    Name = "Shared Subnet"
  })
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.deployment_tags, {
    Name = "Shared Route Table"
  })
}

resource "aws_route_table_association" route_table_association {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

data "aws_ami" "latest-ubuntu-focal" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "basic" {
  description = "Basic Rules"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound SSH connections"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow echo requests (used to ping)"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow destination unreachable messages"
    from_port   = 3
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.deployment_tags, {
    Name = "basic"
  })
}