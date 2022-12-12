terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.44.0"
    }
  }

  backend "gcs" {
    bucket = "rescuenow006-terraform"
  }
}

provider "google" {
  project     = var.gcp_project_id
  credentials = file(var.credentials_path)
}

provider "google-beta" {
  project     = var.gcp_project_id
  credentials = file(var.credentials_path)
}
