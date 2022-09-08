resource "google_dns_managed_zone" "mattsface" {
  name     = "mattsface"
  dns_name = "mattsface.net."
}


resource "google_dns_record_set" "jenkins_cname_record" {
  name         = "jenkins.${google_dns_managed_zone.mattsface.dns_name}"
  type         = "CNAME"
  ttl          = 300
  project      = local.project
  managed_zone = google_dns_managed_zone.mattsface.name
  rrdatas      = [google_dns_record_set.nginx_ingress.name]

  depends_on = [
    google_dns_managed_zone.mattsface
  ]
}

resource "google_dns_record_set" "nginx_ingress" {
  name         = "nginx-ingress.${google_dns_managed_zone.mattsface.dns_name}"
  project      = local.project
  managed_zone = google_dns_managed_zone.mattsface.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.nginx_ingress_ext_ip.id]

  depends_on = [
    google_dns_managed_zone.mattsface
  ]
}

resource "google_compute_global_forwarding_rule" "nginx_ingress_fw_https" {
  name                  = "nginx-ingress-fw-https"
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_ssl_proxy.default.id
  ip_address            = google_compute_global_address.nginx_ingress_ext_ip.id
}

resource "google_compute_global_forwarding_rule" "nginx_ingress_fw_http" {
  name                  = "nginx-ingress-fw-http"
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_ssl_proxy.default.id
  ip_address            = google_compute_global_address.nginx_ingress_ext_ip.id
}

resource "google_compute_backend_service" "nginx-ingress-backend-service" {
  name                  = "nginx-ingress-backend-service"
  protocol              = "TCP"
  port_name             = "tcp"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 1.0
    capacity_scaler = 1.0
  }
}

