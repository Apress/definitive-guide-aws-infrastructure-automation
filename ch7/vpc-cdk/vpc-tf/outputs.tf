output "vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "azs" {
  value = module.dev_vpc.azs
}

output "public_subnet_ids" {
  value = module.dev_vpc.public_subnet_ids
}

output "app_subnet_ids" {
  value = module.dev_vpc.app_subnet_ids
}

output "data_subnet_ids" {
  value = module.dev_vpc.data_subnet_ids
}

output "public_subnet_cidrs" {
  value = module.dev_vpc.public_subnet_cidrs
}

output "app_subnet_cidrs" {
  value = module.dev_vpc.app_subnet_cidrs
}

output "data_subnet_cidrs" {
  value = module.dev_vpc.data_subnet_cidrs
}
