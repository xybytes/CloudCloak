// Read the user data from an external file for haproxy
data "template_file" "script_socks5" {
  template = file("${path.module}/config/socks5.sh")
}

// Create n proxy instances
resource "aws_instance" "ec2_proxy" {
  ami                         = "ami-00eeedc4036573771"
  instance_type               = "t2.micro"
  count                       = var.n
  associate_public_ip_address = true
  key_name                    = aws_key_pair.proxy_key.key_name
  subnet_id                   = aws_subnet.cloudclock_subnet.id
  security_groups             = [aws_security_group.cloudclock_group.id]

  tags = {
    Name = "CloudCloak-proxy"
  }

  // Use the user data from the external file
  user_data = data.template_file.script_socks5.rendered
}


