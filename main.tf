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
resource "google_compute_subnetwork" "subnet-1" {
  name                     = "${var.subnet-1}"
  ip_cidr_range            = "${var.ip_cidr_range_subnet-1}"
  region                   = "${var.region}"
  project                  = "${var.gcp_project}"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  private_ip_google_access = true
  # enable_flow_logs         = true
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "${var.pods_ip_cidr_range}"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "${var.services_ip_cidr_range}"

  }
  secondary_ip_range {
    range_name    = "frontend"
    ip_cidr_range = "${var.frontend_ip_cidr_range}"
  }
}
resource "google_compute_subnetwork" "subnet-2" {
  name                     = "${var.subnet-2}"
  ip_cidr_range            = "${var.ip_cidr_range_subnet-2}"
  region                   = "${var.region}"
  project                  = "${var.gcp_project}"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  private_ip_google_access = true
#  enable_flow_logs         = true
}

// Create a Subnet for bastion-subnet
resource "google_compute_subnetwork" "subnet-3" {
  name                     = "${var.subnet-3}"
  ip_cidr_range            = "${var.ip_cidr_range_subnet-3}"
  region                   = "${var.region}"
  project                  = "${var.gcp_project}"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  private_ip_google_access = true
#  enable_flow_logs         = true
}

// Create a Subnet for proxy-subnet
resource "google_compute_subnetwork" "subnet-4" {
  name                     = "${var.subnet-4}"
  ip_cidr_range            = "${var.ip_cidr_range_subnet-4}"
  region                   = "${var.region}"
  project                  = "${var.gcp_project}"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  private_ip_google_access = true
#  enable_flow_logs         = true
}
// Create a Subnet for proxy-subnet
resource "google_compute_subnetwork" "subnet-5" {
  name                     = "${var.subnet-5}"
  ip_cidr_range            = "${var.ip_cidr_range_subnet-5}"
  region                   = "${var.region}"
  project                  = "${var.gcp_project}"
  network                  = "${var.network}-vpc"
  depends_on               = [google_compute_network.vpc]
  private_ip_google_access = true
#  enable_flow_logs         = true
}