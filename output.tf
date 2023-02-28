data "aws_instances" "proxylist" {
  filter {
    name   = "tag:Name"
    values = ["CloudCloak-proxy"]
  }
}

output "private_ips" {
  description = "List of private IP addresses for all instances with a name starting with 'CloudCloak-'"
  value       = data.aws_instances.proxylist.private_ips
}