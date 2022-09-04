terraform {
 backend "gcs" {}
}

data "terraform_remote_state" "state" {
  backend   = "gcs"
  config    = {
    bucket  = "${google_storage_bucket.tfstate.name}"
    prefix  = "terraform/state"
  }
}