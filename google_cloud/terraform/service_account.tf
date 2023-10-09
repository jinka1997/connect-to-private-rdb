resource "google_service_account" "service_account" {
  account_id   = "${local.environment}-${local.app_name}-service-account"
  display_name = "${local.environment}-${local.app_name}-service-account"
}

resource "google_project_iam_member" "cloud_sql_connection" {
  role    = "roles/cloudsql.client"
  member  = google_service_account.service_account.member
  project = var.myProject
}

resource "google_project_iam_member" "cloud_sql_viewer" {
  role    = "roles/cloudsql.viewer"
  member  = google_service_account.service_account.member
  project = var.myProject
}

resource "google_project_iam_member" "log_writer" {
  role    = "roles/logging.logWriter"
  member  = google_service_account.service_account.member
  project = var.myProject
}
