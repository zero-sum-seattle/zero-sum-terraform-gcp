resource "google_dns_record_set" "a" {
  name         = "jenkins-vm.${google_dns_managed_zone.main.dns_name}"
  project      = local.project
  managed_zone = google_dns_managed_zone.main.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_instance.jenkins-vm.network_interface[0].access_config[0].nat_ip]
}

resource "google_dns_managed_zone" "main" {
  name     = "main"
  dns_name = "mattsface.net."
}
