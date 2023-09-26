resource "random_password" "db-password" {
  length           = 16
  special          = false
  override_special = "!#$&"
}

resource "aws_ssm_parameter" "db_connection_string" {
  data_type = "text"
  name      = "/${local.environment}/connection_strings/${local.app_name}_context"
  tags = {
    Env = local.environment
  }
  tier  = "Standard"
  type  = "SecureString"
  value = "Server=${aws_rds_cluster.aurora_cluster.endpoint};Port=${aws_rds_cluster.aurora_cluster.port};Username=${aws_rds_cluster.aurora_cluster.master_username};Password=${aws_rds_cluster.aurora_cluster.master_password};Database=${aws_rds_cluster.aurora_cluster.database_name}"
}
