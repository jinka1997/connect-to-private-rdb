resource "aws_vpc_endpoint" "s3" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version = "2008-10-17"
    }
  )

  route_table_ids = [
    aws_route_table.private_1a.id,
    aws_route_table.private_1c.id,
  ]
  security_group_ids = []
  service_name       = "com.amazonaws.ap-northeast-1.s3"
  tags = {
    "Name" = "${local.environment}-s3",
    Env    = local.environment
  }
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_vpc_endpoint" "logs" {
  ip_address_type = "ipv4"
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.allow_all_vpc_traffic.id,
  ]
  service_name = "com.amazonaws.ap-northeast-1.logs"
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id,
  ]
  tags = {
    "Name" = "${local.environment}-logs",
    Env    = local.environment
  }
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  dns_options {
    dns_record_ip_type = "ipv4"
  }
  timeouts {}
}

resource "aws_vpc_endpoint" "ssm" {
  ip_address_type = "ipv4"
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id,
  ]
  service_name = "com.amazonaws.ap-northeast-1.ssm"
  subnet_ids = [
    aws_subnet.private_1c.id,
  ]
  tags = {
    "Name" = "${local.environment}-ssm",
    Env    = local.environment
  }
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  dns_options {
    dns_record_ip_type = "ipv4"
  }
  timeouts {}
}

resource "aws_vpc_endpoint" "ssmmessages" {
  ip_address_type = "ipv4"
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id,
  ]
  service_name = "com.amazonaws.ap-northeast-1.ssmmessages"
  subnet_ids = [
    aws_subnet.private_1c.id,
  ]
  tags = {
    "Name" = "${local.environment}-ssmmessages",
    Env    = local.environment
  }
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  dns_options {
    dns_record_ip_type = "ipv4"
  }
  timeouts {}
}

resource "aws_vpc_endpoint" "ec2messages" {
  ip_address_type = "ipv4"
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id,
  ]
  service_name = "com.amazonaws.ap-northeast-1.ec2messages"
  subnet_ids = [
    aws_subnet.private_1c.id,
  ]
  tags = {
    "Name" = "${local.environment}-ec2messages",
    Env    = local.environment
  }
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  dns_options {
    dns_record_ip_type = "ipv4"
  }
  timeouts {}
}

