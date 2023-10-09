resource "google_secret_manager_secret" "connection_string" {
  annotations     = {}
  labels          = {}
  secret_id       = "${local.environment}-${local.app_name}-db-connection-string"
  version_aliases = {}
  replication {
    auto {
    }
  }
  timeouts {}
}

resource "google_secret_manager_secret_version" "version" {
  deletion_policy       = "DELETE"
  enabled               = true
  is_secret_data_base64 = false
  secret                = google_secret_manager_secret.connection_string.id
  secret_data           = "Server=${google_sql_database_instance.instance.connection_name};Port=5432;Username=${google_sql_user.user.name};Password=${google_sql_user.user.password};Database=${google_sql_database.db.name}"
  timeouts {}
}