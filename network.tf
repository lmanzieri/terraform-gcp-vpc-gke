locals {
  subnet_01 = "${var.name}-${var.env}-subnet-01"
  subnet_02 = "${var.name}-${var.env}-subnet-02"
}

resource "google_project_service" "compute" {
  project = var.project
    service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 8.1"

  project_id   = var.project
  network_name = "${var.name}-${var.env}-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.subnet_01
      subnet_ip             = var.subnet_01_configs.subnet_ip
      subnet_region         = var.region
      subnet_private_access = var.subnet_01_configs.subnet_private_access
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = var.subnet_02_configs.subnet_ip
      subnet_region         = var.region
      subnet_private_access = var.subnet_02_configs.subnet_private_access
    }
  ]

  secondary_ranges = {
    (local.subnet_01) = [
      {
        range_name    = "${local.subnet_01}-pod"
        ip_cidr_range = var.subnet_01_configs.secondary_subnet_ip_pod
      },
      {
        range_name    = "${local.subnet_01}-svc"
        ip_cidr_range = var.subnet_01_configs.secondary_subnet_ip_svc
      }
    ]

    (local.subnet_02) = [
      {
        range_name    = "${local.subnet_02}-pod"
        ip_cidr_range = var.subnet_02_configs.secondary_subnet_ip_pod
      },
      {
        range_name    = "${local.subnet_02}-svc"
        ip_cidr_range = var.subnet_02_configs.secondary_subnet_ip_svc
      }
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "kubernetes-${var.name}-${var.env}"
      next_hop_internet = "true"
    }
  ]

  depends_on = [google_project_service.compute]

}

resource "google_compute_router" "router" {
  name    = "${var.name}-${var.env}-router"
  region  = var.region
  network = module.vpc.network_name

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "router_nat" {
  name                               = "${var.name}-${var.env}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}