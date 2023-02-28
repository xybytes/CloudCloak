// Create haproxy instance
resource "aws_instance" "ec2_haproxy" {
  ami                         = "ami-00eeedc4036573771"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.proxy_key.key_name
  subnet_id                   = aws_subnet.cloudclock_subnet.id
  security_groups             = [aws_security_group.cloudclock_group.id]

  tags = {
    Name = "CloudCloak-haproxy"
  }

}
