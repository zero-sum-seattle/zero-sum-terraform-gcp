
resource "google_service_account" "letsencrypt_dns" {
  account_id   = "dns-letsencrypt"
  display_name = "Lets Encrypt DNS Service Account"
}

resource "google_project_iam_member" "letsencrypt_dns_role" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.letsencrypt_dns.email}"
  project = local.project
}

resource "google_service_account_key" "letsencrypt_dns_key" {
  service_account_id = "${google_service_account.letsencrypt_dns.name}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "letsencrypt_credentials_json" {
  content  = "${google_service_account_key.letsencrypt_dns_key.private_key}"
  filename = "letsencrypt-credentials.json.base64"
}

resource "google_service_account_iam_member" "cert_manager_workload_identity" {
  service_account_id = google_service_account.letsencrypt_dns.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project}.svc.id.goog[cert-manager/cert-manager]"
  }