terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "google" {
  project = var.gcp_project
}

terraform {
  backend "gcs" {
    bucket = "bergmans-services-assets"
    prefix = "terraform/state"
  }
}
