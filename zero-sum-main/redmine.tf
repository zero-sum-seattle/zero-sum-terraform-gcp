resource "google_service_account" "redmine" {
  project      = local.project
  account_id   = "redmine"
  display_name = "redmine"
  description  = "redmine"
}

resource "google_project_iam_member" "redmine_cloudsql" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.redmine.email}"
}

resource "google_sql_database_instance" "redmine-db" {
  project          = local.project
  name             = "redmine-db"
  database_version = "MYSQL_8_0"
  region           = local.region

  settings {
    tier = "db-f1-micro"

    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_database" "unity-polr-mysql-db" {
  project = local.project
  name     = "bitnami_redmine"
  instance = google_sql_database_instance.redmine-db.name
  charset  = "UTF8"
}

resource "google_service_account_iam_member" "redmine_workload_identity" {
  service_account_id = google_service_account.redmine.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project}.svc.id.goog[redmine/redmine]"
}