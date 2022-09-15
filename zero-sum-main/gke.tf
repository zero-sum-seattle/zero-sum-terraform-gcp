locals {
  cluster_name = "zero-sum-seattle-${local.environment}-gke"
}

resource "google_container_cluster" "primary" {
  name     = "${local.project}-gke-cluster"
  location = local.region

  remove_default_node_pool = true
  initial_node_count       = 1
  
  workload_identity_config {
    workload_pool = "${local.project}.svc.id.goog"
  }

  network    = google_compute_network.main_vpc_network.name
  subnetwork = google_compute_subnetwork.main_subnet.name
}

resource "google_container_node_pool" "primary_nodes" {
  name       = local.cluster_name
  location   = local.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_number_nodes
  
  node_config {
    // I'll fix the scopes later
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    workload_metadata_config {
    mode = "GKE_METADATA"
    }

    labels = {
      env = local.project
    }

    machine_type = "e2-standard-2"
    tags         = ["gke-node", "${local.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
