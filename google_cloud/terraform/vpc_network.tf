resource "google_compute_network" "vpc" {
  name                    = "${local.environment}-${local.app_name}-vpc"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  timeouts {}
}

resource "google_compute_subnetwork" "subnet1" {
  ip_cidr_range            = local.subnet_cidr_block
  name                     = "${local.environment}-${local.app_name}-subnet"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true # 限定公開のGoogleアクセス https://cloud.google.com/vpc/docs/private-google-access?hl=ja
  timeouts {}
}

resource "google_compute_firewall" "iap" {
  description = "from Internet Aware Proxy"
  direction   = "INGRESS"
  name        = "${local.environment}-${local.app_name}-iap-ingress"
  network     = google_compute_network.vpc.id
  source_ranges = [
    "35.235.240.0/20", # これないとダメ。https://cloud.google.com/iap/docs/using-tcp-forwarding?hl=ja
  ]
  target_tags = [
    local.bastion_target_tag,
  ]
  allow {
    ports = [
      "22",
      "5432",
    ]
    protocol = "tcp"
  }
  timeouts {}
}

resource "google_compute_global_address" "for_private_access" {
  address_type  = "INTERNAL"
  name          = "${local.environment}-${local.app_name}-private-service-access"
  network       = google_compute_network.vpc.id
  prefix_length = 24
  purpose       = "VPC_PEERING"
  timeouts {}
}

resource "google_service_networking_connection" "peering_connection" {
  network = google_compute_network.vpc.id
  reserved_peering_ranges = [
    google_compute_global_address.for_private_access.name,
  ]
  service = "servicenetworking.googleapis.com"
  timeouts {}
}

resource "google_compute_network_peering_routes_config" "routes_config" {
  export_custom_routes = false
  import_custom_routes = false
  network              = google_compute_network.vpc.name
  peering              = google_service_networking_connection.peering_connection.peering
  timeouts {}
}