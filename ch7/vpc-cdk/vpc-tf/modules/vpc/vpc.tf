resource "aws_vpc" "vpc" {
  cidr_block           = var.base_cidr
  instance_tenancy     = "default"
  enable_dns_support   = var.aws_dns
  enable_dns_hostnames = var.aws_dns

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}
