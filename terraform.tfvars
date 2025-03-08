variable "project_id" {}
variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-a" }
variable "instance_name" {}
variable "machine_type" { default = "e2-medium" }
variable "image" { default = "debian-cloud/debian-11" }
variable "disk_size" { default = 20 }
variable "network" { default = "default" }
