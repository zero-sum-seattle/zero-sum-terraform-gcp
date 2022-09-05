// this won't be needed once vault is all set up
resource "google_service_account" "ansible" {
  project      = local.project
  account_id   = "${var.ansible}"
}

resource "google_project_iam_member" "ansible_iam" {
  project = local.project
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.ansible.email}"
}

//resource "google_os_login_ssh_public_key" "ansible_ssh_public" {
//  user = google_service_account.ansible.email
//  key  = file("~/.ansible/ssh/ansible_public.pub")
//}