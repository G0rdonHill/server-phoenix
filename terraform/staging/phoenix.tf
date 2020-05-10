provider "google" {
  credentials=file("${var.credentials}")
  project = var.project
  region  = var.region
  zone    = var.zone
  version = "~> 3.20"
}

variable "project" {
  type = string
  description = "GCP Project ID"
  default = "gh-test-project-1-276520"
  
}
variable "region" {
  type = string
  description = "Region for the GCP resources"
  default = "us-central1"

}

variable "zone" {
  type = string
  description = "Zone for the GCP resources"
  default = "us-central1-c"

}
variable "credentials" {
  type = string
  description="File location for SA Key"
  default="./gh-test-sa-1-key.json"
}

# Module will be moved to a separate repo in future.
module "gcp_compute" {
  source = "../modules/gcp_compute"

  node_count = 1
  prefix = "gh-mod-test"
  vm_size = "f1-micro"
  os = "ubuntu-os-cloud/ubuntu-1804-lts"
  gce_ssh_user = "devops"
  gce_ssh_pub_key_file = "~/.ssh/gcp_id.pub"
  disk_size = "15"

}
