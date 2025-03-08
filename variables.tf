variable "project" { 
  description = "GCP Project ID"
  type        = string 
}
variable "region" { 
  description = "GCP Region"
  type = string
}

variable "zone" {
  description = "GCP Zone"
  type = string
}

variable "machine_type" {
  description = "VM Machine Type"
  type = string
  default = "e2-micro"
}

variable "gcp_credentials_file" {
  description = "GCP Credential"
  type = string
  default = "~/.gcp-key.json"
}
