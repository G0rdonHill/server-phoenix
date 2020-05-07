variable "prefix" {
  type = string
  description = "Prefix for naming scheme"
  default = "gh-test"
  
}

variable "gce_ssh_user" {
    type = string
    description = "SSH user for login to GCE instance"
    default = "gordon"
}

variable "gce_ssh_pub_key_file" {
    type = string
    description = "Loction for public key file"
    default = "~/.ssh/gcp_id.pub"
}

variable "node_count" {
  type = string
  description = "Number of compute instances to create"
  default = 1 
  
}

variable "project" {
  type = string
  description = "GCP Project ID"
  default = "gh-test-project-1-276520"
  
}

variable "credentials" {
  type = string
  description="File location for SA Key"
  default="./gh-test-sa-1-key.json"
}

variable "os" {
  type = string
  description = "OS of Compute VM"
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
  
}

variable "disk_size" {
  type = string
  description = "Size in GB of VM data disks."
  default = "20"
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

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the azure resource"

  default = {
      DevOps = "GordonHill"
      Project = "Phoenix"
      Provisioner = "Terraform"
  }
}

variable "compute_size" {
  type = string
  description = "Size of GCP VM"
  default = "f1-micro"
  
}