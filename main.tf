terraform {
  required_providers {
    google = {
      source = "harshicorp/google"
      version = "`> 5.0"
     }
   }
  backend "gcs" {
    bucket = "aka-terraform-bucket"
    prefix = "comput-engine/vm"
  }
}

provider "google" {
  project = var.project.id
  region = var.region
}

resource "google_compute_instance" "vm_instance" {
  name = var.instance_name
  machine_type = var.machine_type
  zone = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size = var.disk_size
    }
  }
  network_interface {
    network = var.network
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_sript = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<html><head><title>Welcome</title></head><body><h1>Welcome to My GCP VM!</h1></body></html>" | sudo tee //bar/www/html/index.html
   EOT

   service_account {
    email = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_servie_account" "vm_sa" {
  account_id = "vm-service-account"
  display_name = "VM Service Account"
}

resource "google_compute_firewall" "allow_http" {
  name = "allow-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports = ["80"]
}

source_ranges = ["0.0.0.0/0"]
}

output "vm_external_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
