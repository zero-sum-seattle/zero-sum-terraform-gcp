resource "google_dns_managed_zone" "zero_sum" {
  name     = "zero-sum"
  dns_name = "zero-sum-seattle.net."
}

resource "google_dns_record_set" "zone_soa_ttl" {
  type         = "SOA"
  ttl          = 1200
  project      = local.project
  name         = google_dns_managed_zone.zero_sum.dns_name
  managed_zone = google_dns_managed_zone.zero_sum.name
  rrdatas = ["ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"]
}

resource "google_dns_record_set" "zone_ns_ttl" {
  type         = "NS"
  ttl          = 1200
  project      = local.project
  name         = google_dns_managed_zone.zero_sum.dns_name
  managed_zone = google_dns_managed_zone.zero_sum.name
  rrdatas = [ 
    "ns-cloud-b1.googledomains.com.",
    "ns-cloud-b2.googledomains.com.",
    "ns-cloud-b3.googledomains.com.",
    "ns-cloud-b4.googledomains.com."
  ]
}

resource "google_dns_record_set" "jenkins_cname_record" {
  name         = "jenkins.${google_dns_managed_zone.zero_sum.dns_name}"
  type         = "CNAME"
  ttl          = 300
  project      = local.project
  managed_zone = google_dns_managed_zone.zero_sum.name
  rrdatas      = [google_dns_record_set.nginx_ingress.name]

  depends_on = [
    google_dns_managed_zone.zero_sum
  ]
}

resource "google_dns_record_set" "jenkins_cname_record" {
  name         = "redmine.${google_dns_managed_zone.zero_sum.dns_name}"
  type         = "CNAME"
  ttl          = 300
  project      = local.project
  managed_zone = google_dns_managed_zone.zero_sum.name
  rrdatas      = [google_dns_record_set.nginx_ingress.name]

  depends_on = [
    google_dns_managed_zone.zero_sum
  ]
}

resource "google_dns_record_set" "nginx_ingress" {
  name         = "nginx-ingress.${google_dns_managed_zone.zero_sum.dns_name}"
  project      = local.project
  managed_zone = google_dns_managed_zone.zero_sum.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_address.nginx_ingress_ext_ip.address]

  depends_on = [
    google_dns_managed_zone.zero_sum
  ]
}

