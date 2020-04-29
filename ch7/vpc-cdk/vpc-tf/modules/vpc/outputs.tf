output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "azs" {
  value = slice(local.azs, 0, local.num_azs > local.max_azs ? local.max_azs : local.num_azs)
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "app_subnet_ids" {
  value = aws_subnet.app.*.id
}

output "data_subnet_ids" {
  value = aws_subnet.data.*.id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public.*.cidr_block
}

output "app_subnet_cidrs" {
  value = aws_subnet.app.*.cidr_block
}

output "data_subnet_cidrs" {
  value = aws_subnet.data.*.cidr_block
}
