output "state_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "cluster_name" {
  value = google_container_node_pool.primary_nodes.name 
}

output "jenkins_ext_ip" {
  value = "${google_compute_instance.jenkins-vm.network_interface.0.access_config.0.nat_ip}"
}