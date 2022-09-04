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

resource "google_compute_instance" "jenkins-vm" {
  name = "jenkins-vm"

  // this will work for testing, but not deployments
  machine_type = "n1-standard-1"
  tags = ["jenkins"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.centos7-image.self_link
      size  = "20"
    }
    auto_delete = true
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main_subnet.name
  }

  // This will work until a packer image is ready or I move jenkins to GKE 
  metadata_startup_script = <<SCRIPT
    yum install -y wget
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum upgrade
    sudo yum install epel-release java-11-openjdk-devel
    sudo yum install jenkins
    sudo systemctl daemon-reload
    SCRIPT

  service_account {
    email = google_service_account.jenkins.email
    // I'll scale this back to what is needed
    scopes = ["cloud-platform"]
  }
}








