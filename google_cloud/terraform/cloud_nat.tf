resource "google_compute_router_nat" "nat" {
  name                               = "${local.environment}-${local.app_name}-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = false
    filter = "ALL"
  }
  timeouts {}
}

resource "google_compute_router" "router" {
  encrypted_interconnect_router = false
  name                          = "${local.environment}-${local.app_name}-router"
  network                       = google_compute_network.vpc.id
  timeouts {}
}

