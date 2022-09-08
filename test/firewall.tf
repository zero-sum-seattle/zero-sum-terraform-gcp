﻿resource "google_compute_firewall" "ssh" {
  name    = "${var.network}-firewall-ssh"
  network = "${google_compute_network.main_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["${var.network}-firewall-ssh", "jenkins"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "${var.network}-firewall-http"
  network = "${google_compute_network.main_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["${var.network}-firewall-http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https" {
  name    = "${var.network}-firewall-https"
  network = "${google_compute_network.main_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["${var.network}-firewall-https", "jenkins"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "icmp" {
  name    = "${var.network}-firewall-icmp"
  network = "${google_compute_network.main_vpc_network.name}"

  allow {
    protocol = "icmp"
  }

  target_tags   = ["${var.network}-firewall-icmp", "jenkins"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tcp-8080" {
  name = "${var.network}-firewall-tcp-8080"
  network = "${google_compute_network.main_vpc_network.name}"

  allow {
      protocol = "tcp"
      ports   = ["8080"]
  }  

  target_tags = ["${var.network}-firewall-tcp-8080", "jenkins"]
  source_ranges = ["0.0.0.0/0"]
}
