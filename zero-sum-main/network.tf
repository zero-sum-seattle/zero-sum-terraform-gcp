resource "google_compute_network" "main_vpc_network" {
  name        = "${local.project}-main-vpc"
  description = "Main VPC network for project ${local.project}-main-vpc"
}

resource "google_compute_subnetwork" "main_subnet" {
  name          = "${local.project}-main-subnet"
  region        = local.region
  network       = google_compute_network.main_vpc_network.name
  ip_cidr_range = "192.168.16.0/24"
}

resource "google_compute_address" "nginx_ingress_ext_ip" {
  name         = "nginx-ingress-ext-ip"
  address_type = "EXTERNAL"
  project      = local.project
  region       = local.region
}


