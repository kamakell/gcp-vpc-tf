### Rule 01 = Source: GCP-GKE to Destination: On-Prem-abc ###
resource "google_compute_firewall" "rule1" {
  name    = "${var.network}-rule1"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
    description = "Source: GKE to Destination:VF-Onpremise on port 3333 (SMSC)"
  enable_logging = "true"
  direction = "EGRESS"
  priority = "1000"
  destination_ranges = ["10.44.153.64/32", "10.44.153.65/32", "10.44.153.66/32", "10.44.153.67/32"]
    allow {
    protocol = "tcp"
    ports    = ["3333"]
  }
  target_tags = ["gke"]

}
### Rule 02 = Source: On-Prem-Jenkins to GKE ###

resource "google_compute_firewall" "rule2" {
  name    = "${var.network}-rule2"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
    description = "Source: VF-Onpremise Jenkins (443) to Destination:GKE"
  enable_logging = "true"
  priority = "1000"
  source_ranges = ["10.44.153.32/32"]
    allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["gke"]
}

### Rule 03 = Controlling using a Service Account ###

resource "google_compute_firewall" "rule3" {
  name    = "${var.network}-rule3"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  enable_logging = "true"
  priority = "1010"
  source_ranges = ["0.0.0.0/0"]
  source_service_accounts = ["hpa01-a@sales-eu01.iam.gserviceaccount.com"]
   allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_service_accounts  = ["hpa01-a@sales-eu01.iam.gserviceaccount.com"]
   allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

### Rule 04 = Controlling using Source and Target Tags ###

resource "google_compute_firewall" "rule4" {
  name    = "${var.network}-rule4"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  enable_logging = "true"
  priority = "1020"
  target_tags = ["vcd"]
  source_tags = ["abc"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
