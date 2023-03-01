// Create VPC
resource "aws_vpc" "cloudclock_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "CloudCloak-VPC"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudclock_vpc.id

}


// Route tables
resource "aws_route_table" "tf" {
  vpc_id = aws_vpc.cloudclock_vpc.id

  // Route to the internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}


// Create public subnet
resource "aws_subnet" "cloudclock_subnet" {
  vpc_id                  = aws_vpc.cloudclock_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "CloudCloak-Subnet"
  }
}


// Associate route table to subnet
resource "aws_route_table_association" "route_tf" {
  subnet_id      = aws_subnet.cloudclock_subnet.id
  route_table_id = aws_route_table.tf.id
}


// Create security group
resource "aws_security_group" "cloudclock_group" {
  name        = "cloudclock_group"
  description = "Allow SSH,Socks5 and ICMP from my IP address only"
  vpc_id      = aws_vpc.cloudclock_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_address]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.ip_address]
  }

  ingress {
    from_port   = 1080
    to_port     = 1080
    protocol    = "tcp"
    cidr_blocks = [var.ip_address]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// This allows all traffic from any source within the same security group.
resource "aws_security_group_rule" "allow_internal_traffic" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = aws_security_group.cloudclock_group.id
  security_group_id        = aws_security_group.cloudclock_group.id
}
