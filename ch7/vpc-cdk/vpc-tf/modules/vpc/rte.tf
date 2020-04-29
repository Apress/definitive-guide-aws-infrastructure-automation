resource "aws_route" "pub_default" {
  route_table_id         = aws_route_table.pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = ["aws_route_table.pub"]
}

resource "aws_route" "priv_default" {
  count = var.high_availability ? (local.num_azs > local.max_azs ? local.max_azs : local.num_azs) : 1

  route_table_id         = aws_route_table.priv[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id
  depends_on             = ["aws_route_table.priv"]
}
