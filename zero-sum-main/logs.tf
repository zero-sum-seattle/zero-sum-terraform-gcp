

#
# This is a REAL quick job. I am having issues troubleshooting a Google API and need some logs to review
# This solution here is not ideal and will be addressed once I get some time


resource "google_storage_bucket" "log-bucket" {
  name     = "zero-sum-logging-bucket"
  location = "US" 
  force_destroy = true
} 

