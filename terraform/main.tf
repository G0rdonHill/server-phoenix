# Will improve using the below article
## https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d


provider "google" {
  credentials=file("${var.credentials}")
  project = var.project
  region  = var.region
  zone    = var.zone
  version = "~> 3.20"
}

# resource "google_compute_disk" "vm" {

#   count = var.node_count

#   name  = "${var.prefix}-disk${count.index}"
#   type  = "pd-standard"
#   zone  = var.zone
#   labels = {
#     environment = "dev"
#   }
#   size = var.disk_size
# }

output "gcp_instance_public_ip" {
  value = google_compute_instance.vm[*].network_interface.0.access_config.0.nat_ip
}


resource "google_compute_instance" "vm" {
  count = var.node_count

  name         = "${var.prefix}-vm${count.index}"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = var.os
    }
  }
  # attached_disk {
  #   source = google_compute_disk.vm[count.index].name
  # }
  network_interface {
    # A default network is created for all GCP projects
    network       = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "icmp" {
  name    = "${var.prefix}-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

}
resource "google_compute_firewall" "ssh" {
  name    = "${var.prefix}-ssh"
  network = google_compute_network.vpc_network.name
  allow{
    protocol = "tcp"
    ports = ["22"]
  }
}
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.prefix}-internal"
  network = google_compute_network.vpc_network.name
  allow{
    protocol="tcp"
    ports = ["0-65535"]
  }
  allow{
    protocol="tcp"
    ports = ["0-65535"]
  }
  allow{
    protocol="icmp"
  }
  source_ranges=["10.128.0.0/9"]
}
  # allow {
  #   protocol = "tcp"
  #   ports    = ["80", "8080", "1000-2000"]
  # }

  # source_tags = ["web"]

