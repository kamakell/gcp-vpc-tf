terraform {
  backend "gcs" {
    bucket  = "sales-eu01-shared"
    prefix  = "terraform/state"
  }
}
// Configure the Google Cloud provider
provider "google" {
 # credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}"
 region      = "${var.region}"
}
// Create VPC
resource "google_compute_network" "vpc" {
 name                    = "${var.network}-vpc"
 auto_create_subnetworks = "false"
}

// Create Subnet
resource "google_compute_subnetwork" "public" {
 name          = "${var.network}-public"
 description   = "This subnet is Public Subnetwork"
 ip_cidr_range = "${var.public_cidr}"
 network       = "${var.network}-vpc"
 depends_on    = [google_compute_network.vpc]
 region      = "${var.region}"
 private_ip_google_access = "${var.private_google_access}"
 }

resource "google_compute_subnetwork" "private" {
 name          = "${var.network}-private"
 ip_cidr_range = "${var.secondary_subnet_cidr}"
 network       = "${var.network}-vpc"
 depends_on    = [google_compute_network.vpc]
 region      = "${var.region}"
}
// VPC Route Configuration
resource "google_compute_route" "route-igw" {
  name         = "route-igw"
  dest_range   = "${var.igw}"
  network      = "${var.network}-vpc"
  depends_on    = [google_compute_network.vpc]
  next_hop_ip = "${var.hop}"
  priority     = "${var.priority}"
}
// VPC firewall configuration
resource "google_compute_firewall" "firewall" {
  name    = "${var.network}-firewall"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
// Create Public / External IP
#resource "google_compute_address" "address" {
#count = 1
#name = "${var.network}-external-address-${count.index}"
#region = "${var.region}"
#}
