resource "google_service_account" "jenkins" {
  project      = local.project
  account_id   = "jenkins"
  display_name = "jenkins"
}

