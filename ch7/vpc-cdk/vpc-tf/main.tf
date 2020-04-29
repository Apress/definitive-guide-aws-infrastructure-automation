module "dev_vpc" {
  source = "./modules/vpc"

  base_cidr         = "10.0.0.0/16"
  aws_dns           = true
  vpc_name          = "dev"
  environment       = "dev"
  high_availability = false
}
