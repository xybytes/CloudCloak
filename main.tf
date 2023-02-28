provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

// SSH Keys
resource "aws_key_pair" "proxy_key" {
  key_name   = "proxy_key"
  public_key = file("~/.ssh/proxy_key.pub")
}




