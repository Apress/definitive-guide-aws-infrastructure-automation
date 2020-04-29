resource "aws_route_table_association" "pub" {
  count          = local.num_azs > local.max_azs ? local.max_azs : local.num_azs
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "app" {
  count          = local.num_azs > local.max_azs ? local.max_azs : local.num_azs
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.priv[var.high_availability ? count.index : 0].id
}

resource "aws_route_table_association" "data" {
  count          = local.num_azs > local.max_azs ? local.max_azs : local.num_azs
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.priv[var.high_availability ? count.index : 0].id
}
