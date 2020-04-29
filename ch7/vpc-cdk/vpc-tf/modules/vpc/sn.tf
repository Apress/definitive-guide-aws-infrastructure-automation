resource "aws_subnet" "public" {
  count                   = local.num_azs > local.max_azs ? local.max_azs : local.num_azs
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.base_cidr, 4, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-pub-${substr(local.azs[count.index], -2, 2)}"
    Tier = "public"
  }
}

resource "aws_subnet" "app" {
  count                   = local.num_azs > local.max_azs ? local.max_azs : local.num_azs
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.base_cidr, 4, local.max_azs + count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-app-${substr(local.azs[count.index], -2, 2)}"
    Tier = "app"
  }
}

resource "aws_subnet" "data" {
  count                   = local.num_azs > local.max_azs ? local.max_azs : local.num_azs
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.base_cidr, 4, (local.max_azs * 2) + count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-data-${substr(local.azs[count.index], -2, 2)}"
    Tier = "data"
  }
}
