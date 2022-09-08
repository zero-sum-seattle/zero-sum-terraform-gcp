output "state_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "cluster_name" {
  value = google_container_node_pool.primary_nodes.name 
}

