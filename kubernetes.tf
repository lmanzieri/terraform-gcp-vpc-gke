resource "google_project_service" "container" {
  project = var.project
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "29.0.0"

  kubernetes_version = "1.27.3-gke.100"

  project_id = var.project
  name       = "kubernetes-${var.name}-${var.env}"

  regional                  = false
  region                    = var.region
  zones                     = ["${var.region}-b"]
  default_max_pods_per_node = 32

  network                = module.vpc.network_name
  subnetwork             = local.subnet_01
  ip_range_pods          = "${local.subnet_01}-pod"
  ip_range_services      = "${local.subnet_01}-svc"
  master_ipv4_cidr_block = "10.10.11.0/28"

  maintenance_start_time = "2020-08-24T00:00:00Z"
  maintenance_end_time   = "2020-08-25T00:00:00Z"
  maintenance_recurrence = "FREQ=DAILY"

  dns_cache                = false
  enable_private_endpoint  = false
  gke_backup_agent_config  = true
  enable_private_nodes     = true
  gce_pd_csi_driver        = true
  remove_default_node_pool = true
  http_load_balancing      = true
  network_policy           = true
  config_connector         = true
  deletion_protection      = true

  cluster_resource_labels = {
    environment = var.env
    terraform   = "true"
    component   = "kubernetes"
  }

  node_pools = [
    {
      name               = "standard"
      machine_type       = "e2-standard-2"
      min_count          = 1
      max_count          = 4
      disk_size_gb       = 60
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      spot               = true
      enable_secure_boot = true
      initial_node_count = 1
      max_pods_per_node  = 32
    }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  node_pools_labels = {
    all = {
      environment = var.env
      terraform   = "true"
      component   = "kubernetes"
    }
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = ["kubernetes-${var.name}-${var.env}"]
  }

  depends_on = [module.vpc]
}