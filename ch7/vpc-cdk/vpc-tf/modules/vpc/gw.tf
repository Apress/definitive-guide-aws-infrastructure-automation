resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = "${var.environment}"
  }
}

resource "aws_eip" "ngw_eip" {
  count      = var.high_availability ? (local.num_azs > local.max_azs ? local.max_azs : local.num_azs) : 1
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]

  tags = {
    Name        = "${var.vpc_name}-eip${count.index}"
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count         = var.high_availability ? (local.num_azs > local.max_azs ? local.max_azs : local.num_azs) : 1
  allocation_id = aws_eip.ngw_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name        = "${var.vpc_name}-ngw${count.index}"
    Environment = "${var.environment}"
  }
  depends_on = ["aws_internet_gateway.igw"]
}
