resource "aws_vpc" "dojovpc" {
  cidr_block       = "10.0.0.0/26"
  enable_dns_hostnames = true
  tags = {
    Name = "Dojo VPC"
  }
}
