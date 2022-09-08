resource "google_service_account" "jenkins" {
  project      = local.project
  account_id   = "jenkins"
  display_name = "jenkins"
}

resource "google_project_iam_member" "jenkins-role" {
  // pulled these from google docs, will scale back or up if needed
  for_each = toset([
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountActor"
  ])

  role    = each.key
  member  = "serviceAccount:${google_service_account.jenkins.email}"
  project = local.project

}









