resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = local.vpc_cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "Name" = local.environment,
    Env    = local.environment
  }
}

resource "aws_internet_gateway" "igw" {
  tags = {
    "Name" = local.environment,
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_route_table" "public" {
  tags = {
    "Name" = "${local.environment}-${local.app_name}-public",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public_1c" {
  cidr_block        = local.public_1c_cidr_block
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "${local.environment}-${local.app_name}-public-1c",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "public_1c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_1c.id
}

resource "aws_subnet" "private_1a" {
  availability_zone = "ap-northeast-1a"
  cidr_block        = local.private_1a_cidr_block
  tags = {
    "Name" = "${local.environment}-${local.app_name}-private-1a",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_route_table" "private_1a" {
  tags = {
    "Name" = "${local.environment}-${local.app_name}-private-1a",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_subnet" "private_1c" {
  availability_zone = "ap-northeast-1c"
  cidr_block        = local.private_1c_cidr_block
  tags = {
    "Name" = "${local.environment}-${local.app_name}-private-1c",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_route_table" "private_1c" {
  tags = {
    "Name" = "${local.environment}-${local.app_name}-private-1c",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}
