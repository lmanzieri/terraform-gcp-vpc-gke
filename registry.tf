resource "google_project_service" "artifact_registry" {
  project = var.project
  service = "artifactregistry.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_artifact_registry_repository" "artifact_registry" {
  project       = var.project
  location      = var.region
  repository_id = "${var.name}-registry-${var.env}"
  description   = "Docker images registry - Managed by terraform (repo: ${var.name}-infra)"
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry]
}
