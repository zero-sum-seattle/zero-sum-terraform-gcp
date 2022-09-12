variable "gke_number_nodes" {
  type        = number
  default     = 2
  description = "the number of nodes in a gke pool"
}

variable "network" {
  type           = string
  default        = "main-vpc"
  description    = "the number of nodes in a gke pool"
}

variable "dns" {
  type           = string
  default        = "mattsface.net."
  description    = "the number of nodes in a gke pool"
}

variable "ansible" {
  type = string
  default = "ansible"
}

