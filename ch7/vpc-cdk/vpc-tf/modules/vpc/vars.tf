data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  max_azs = 3
  num_azs = length(data.aws_availability_zones.available.names)
  azs     = data.aws_availability_zones.available.names
}

variable "base_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_dns" {
  type = bool
}

variable "vpc_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "high_availability" {
  type = bool
}
