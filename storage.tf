resource "google_storage_bucket" "terraform_state_bucket" {
  name     = "terraform-state-bucket"
  location = var.region

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}