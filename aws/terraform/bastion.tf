resource "aws_instance" "bastion" {
  ami                         = "ami-079cd5448deeace01"
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  instance_type               = "t2.micro"
  #key_name                    = "xxxx" //セッションマネージャで接続するので、キーペア不要
  monitoring = false
  subnet_id  = aws_subnet.private_1c.id
  tags = {
    "Name" = "${local.environment}-bastion",
    Env    = local.environment
  }
  tenancy = "default"
  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }
  timeouts {}
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.environment}-bastion_profile"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  description = "EC2 bastion"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
  max_session_duration = 3600
  name                 = "${local.environment}-bastion-role"
  path                 = "/"
  tags = {
    Env = local.environment
  }
}