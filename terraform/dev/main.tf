provider "google" {
  credentials=file("${var.credentials}")
  project = var.project
  region  = var.region
  zone    = var.zone
  version = "~> 3.20"
}

# Module will be moved to a separate repo in future.
module "gcp_compute" {
  source = "git@github.com:g1212/terraform-modules.git//modules/gcp_compute?ref=master"

  node_count = 1
  prefix = "gh-separate-test"
  vm_size = "f1-micro"
  os = "ubuntu-os-cloud/ubuntu-1804-lts"
  gce_ssh_user = "devops"
  gce_ssh_pub_key_file = "~/.ssh/gcp_id.pub"
  disk_size = "15"

}
