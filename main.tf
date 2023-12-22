terraform {
  required_version = "~> 1.6.0"

  backend "gcs" {}
}

provider "google-beta" {}

provider "google" {
  project = var.project
  region  = var.region
}
