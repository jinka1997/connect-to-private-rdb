resource "google_compute_instance" "bastion" {
  can_ip_forward          = false
  machine_type            = "e2-micro"
  metadata_startup_script = "curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.6.0/cloud-sql-proxy.linux.amd64;chmod +x cloud-sql-proxy;sudo mv ./cloud-sql-proxy /usr/local/bin/ ;cloud-sql-proxy --address 0.0.0.0 --port 5432 --private-ip ${google_sql_database_instance.instance.connection_name}"
  /* 複数行だと動かなかったので、暫定的に1行で記載 ↑
  metadata = {
    "startup-script" = <<-EOF
        #! /bin/bash
        curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.6.0/cloud-sql-proxy.linux.amd64
        chmod +x cloud-sql-proxy
        sudo mv ./cloud-sql-proxy /usr/local/bin/
        cloud-sql-proxy --address 0.0.0.0 --port 5432 --private-ip ${google_sql_database_instance.instance.connection_name}
    EOF     
  }
*/
  name = "${local.environment}-${local.app_name}-bastion"
  tags = [
    local.bastion_target_tag,
  ]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet1.id
  }

  service_account {
    email = google_service_account.service_account.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {}
  depends_on = [
    # startup_scriptでインターネット経由でコネクタをダウンロードするため、
    # NATでインターネット接続ができるようになってからインスタンス作成
    google_compute_router_nat.nat
  ]
  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"]
    ]
  }
}
