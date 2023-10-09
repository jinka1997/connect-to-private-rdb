resource "google_sql_database_instance" "instance" {
  database_version    = "POSTGRES_15"
  deletion_protection = false
  name                = "${local.environment}-${local.app_name}-db-instance"
  settings {
    tier        = "db-custom-2-8192"
    user_labels = {}
    ip_configuration {
      enable_private_path_for_google_cloud_services = true
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc.id
    }
  }
  timeouts {}
  depends_on = [
    google_service_networking_connection.peering_connection
  ]
}

resource "google_sql_database" "db" {
  name     = "${local.environment}-${local.app_name}-db"
  instance = google_sql_database_instance.instance.name
}

resource "random_string" "db_password" {
  length  = 12
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "google_sql_user" "user" {
  name     = "${local.environment}-${local.app_name}-user"
  instance = google_sql_database_instance.instance.name
  password = random_string.db_password.result
}

