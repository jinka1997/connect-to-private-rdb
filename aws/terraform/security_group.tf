resource "aws_security_group" "allow_all_vpc_traffic" {
  description = "${local.environment}-${local.app_name}-allow-all-vpc-traffic"
  name        = "${local.environment}-${local.app_name}-allow-all-vpc-traffic"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        local.vpc_cidr_block,
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]
  tags = {
    Name = "${local.environment}-${local.app_name}-allow-all-vpc-traffic",
    Env  = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}


resource "aws_security_group" "bastion" {
  description = "bastion"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        var.proxy_ip_address
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]
  name = "${local.environment}-${local.app_name}-bastion"
  tags = {
    "Name" = "${local.environment}-${local.app_name}-bastion",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}


resource "aws_security_group" "db" {
  description = "Aurora"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks      = []
      description      = "allow bastion only"
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups = [
        aws_security_group.bastion.id,
      ]
      self    = false
      to_port = 5432
    },
  ]
  name = "${local.environment}-${local.app_name}-aurora-cluster"
  tags = {
    "Name" = "${local.environment}-${local.app_name}-aurora-cluster",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}

resource "aws_security_group" "ssm" {
  description = "ssm"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        local.vpc_cidr_block,
      ]
      description      = ""
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
  ]
  name = "${local.environment}-${local.app_name}-ssm"
  tags = {
    "Name" = "${local.environment}-${local.app_name}-ssm",
    Env    = local.environment
  }
  vpc_id = aws_vpc.vpc.id
  timeouts {}
}
