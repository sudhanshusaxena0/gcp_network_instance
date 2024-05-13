resource "google_compute_network" "vpc" {
  auto_create_subnetworks                   = false
  delete_default_routes_on_create           = false
  enable_ula_internal_ipv6                  = false
  mtu                                       = 1460
  name                                      = var.vpc_name
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  routing_mode                              = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  ip_cidr_range              = var.cidr_range
  name                       = var.subnet_name
  network                    = google_compute_network.vpc.self_link
  private_ip_google_access   = false
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  stack_type                 = "IPV4_ONLY"
}

resource "google_compute_firewall" "firewall" {
  direction = "INGRESS"
  disabled  = false
  name      = "iap-ingress"
  network   = google_compute_network.vpc.self_link
  priority  = 1000
  source_ranges = [
    "35.235.240.0/20",
  ]

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_instance" "instance" {
  boot_disk {
    auto_delete = true
    device_name = "${var.machine_name}-${var.zone}"

    initialize_params {
      image = var.machine_image
      size  = 20
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = var.machine_type

  metadata = {
    startup-script = "sudo update-crypto-policies --set DEFAULT:SHA1\nsudo systemctl restart sshd"
  }

  name = "${var.machine_name}-${var.zone}"

  network_interface {
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.subnet.self_link
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = var.zone
}
