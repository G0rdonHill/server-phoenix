variable "prefix" {
  type = string
  description = "Prefix for naming scheme"

}

variable "gce_ssh_user" {
    type = string
    description = "SSH user for login to GCE instance"
    default = "gordon"
}

variable "gce_ssh_pub_key_file" {
    type = string
    description = "Loction for public key file"

}

variable "node_count" {
  type = string
  description = "Number of compute instances to create"
  default = 1

}

variable "vm_size" {
  type = string
  description = "GCP Compute instance size"
}

variable "os" {
  type = string
  description = "OS of Compute VM"
  default = "ubuntu-os-cloud/ubuntu-1804-lts"

}

variable "disk_size" {
  type = string
  description = "Size in GB of VM data disks."
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