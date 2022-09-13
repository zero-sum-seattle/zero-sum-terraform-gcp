output "state_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "cluster_name" {
  value = google_container_node_pool.primary_nodes.name 
}

output "ext_nginx_ip" {
  value = google_compute_address.nginx_ingress_ext_ip.address 
  
}