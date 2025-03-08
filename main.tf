terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
     }
   }
 }

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_firewall" "allow_http" {
  name = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web-server"]
}

resource "google_compute_firewall" "allow_ssh" {
  name = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web-server"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Assign a public IP
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<html><head><title>Welcome</title></head><body><h1>Welcome to My GCP WebServer!</h1></body></html>" | sudo tee /var/www/html/index.html
   EOF
}
