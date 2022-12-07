terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    linode = {
      source = "linode/linode"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "google" {
  project = var.gcp_project
}

provider "linode" {
  token = var.linode_token
}

terraform {
  backend "gcs" {
    bucket = "bergmans-services-assets"
    prefix = "terraform/state"
  }
}
