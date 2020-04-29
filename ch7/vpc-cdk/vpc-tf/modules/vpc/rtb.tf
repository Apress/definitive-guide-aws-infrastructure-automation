resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-pub"
    Environment = var.environment
  }
}

resource "aws_route_table" "priv" {
  count  = var.high_availability ? (local.num_azs > local.max_azs ? local.max_azs : local.num_azs) : 1
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-priv${count.index}"
    Environment = var.environment
  }
}
