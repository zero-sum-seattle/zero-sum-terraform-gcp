resource "google_project_iam_custom_role" "dns_owner" {
  role_id     = "dns_owner"
  title       = "DNS Owner"
  description = "Allows service account to manage DNS."

  permissions = [
    "dns.changes.create",
    "dns.changes.get",
    "dns.managedZones.list",
    "dns.resourceRecordSets.create",
    "dns.resourceRecordSets.delete",
    "dns.resourceRecordSets.list",
    "dns.resourceRecordSets.update",
  ]
}

resource "google_service_account" "letsencrypt_dns" {
  account_id   = "dns-letsencrypt"
  display_name = "Lets Encrypt DNS Service Account"
}

resource "google_project_iam_member" "letsencrypt_dns_role" {
  role    = "projects/${local.project}/roles/${google_project_iam_custom_role.dns_owner.role_id}"
  member  = "serviceAccount:${google_service_account.letsencrypt_dns.email}"
  project = local.project
}

resource "google_service_account_key" "letsencrypt_dns" {
  service_account_id = "${google_service_account.letsencrypt_dns.name}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "letsencrypt_credentials_json" {
  content  = "${google_service_account_key.letsencrypt_dns.private_key}"
  filename = "letsencrypt-credentials.json.base64"
}