resource "aws_db_subnet_group" "group" {
  description = local.environment
  name        = local.environment
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id,
  ]
  tags = {
    Env = local.environment
  }
}

resource "aws_rds_cluster_parameter_group" "cluster_pg" {
  description = "${local.environment}-cluster-aurora-postgresql15"
  family      = "aurora-postgresql15"
  name        = "${local.environment}-cluster-aurora-postgresql15"
  tags = {
    Env = local.environment
  }
}

resource "aws_db_parameter_group" "pg" {
  description = "${local.environment}-aurora-postgresql15"
  family      = "aurora-postgresql15"
  name        = "${local.environment}-aurora-postgresql15"
  tags = {
    Env = local.environment
  }
}


resource "aws_rds_cluster" "aurora_cluster" {
  backtrack_window                    = 0
  backup_retention_period             = 1
  cluster_identifier                  = "${local.environment}-${local.app_name}-cluster"
  copy_tags_to_snapshot               = true
  database_name                       = "${local.app_name}${local.environment}"
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.cluster_pg.name
  db_subnet_group_name                = aws_db_subnet_group.group.name
  deletion_protection                 = false
  enable_http_endpoint                = false
  enable_global_write_forwarding      = false
  enabled_cloudwatch_logs_exports     = []
  engine                              = "aurora-postgresql"
  engine_mode                         = "provisioned"
  engine_version                      = "15.3"
  iam_database_authentication_enabled = false
  skip_final_snapshot                 = true
  master_username                     = "admin${local.environment}"
  master_password                     = random_password.db-password.result
  network_type                        = "IPV4"
  port                                = 5432
  tags = {
    Env = local.environment
  }
  vpc_security_group_ids = [
    aws_security_group.db.id,
  ]
  timeouts {}
}

resource "aws_rds_cluster_instance" "instance1" {
  auto_minor_version_upgrade   = false
  ca_cert_identifier           = "rds-ca-ecc384-g1"
  identifier                   = "${local.environment}-${local.app_name}-writer"
  cluster_identifier           = aws_rds_cluster.aurora_cluster.cluster_identifier
  copy_tags_to_snapshot        = false
  engine                       = "aurora-postgresql"
  engine_version               = "15.3"
  instance_class               = "db.t3.medium"
  monitoring_role_arn          = aws_iam_role.aurora_monitor.arn
  monitoring_interval          = 60
  performance_insights_enabled = true
  promotion_tier               = 1
  db_parameter_group_name      = aws_db_parameter_group.pg.name
  publicly_accessible          = false
  tags = {
    Env = local.environment
  }
  timeouts {}
}

resource "aws_iam_role" "aurora_monitor" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "monitoring.rds.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  description = "aurora monitor"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole",
  ]
  max_session_duration = 3600
  name                 = "${local.environment}-rds-monitoring-role"
  path                 = "/"
  tags = {
    Env = local.environment
  }
}