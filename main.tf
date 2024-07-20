resource "google_compute_network" "tf-gcp" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf-gcp" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west2"
  network       = google_compute_network.tf-gcp.id
  secondary_ip_range {
    range_name    = "sub-range-test"
    ip_cidr_range = "192.168.10.0/24"
  }
}

data "google_compute_image" "ubuntu" {
  most_recent = true
  project     = "ubuntu-os-cloud" 
  family      = "ubuntu-2204-lts"
}

resource "google_compute_instance" "web" {
  name         = "tf-test"
  machine_type = "e2-micro"

  
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
   subnetwork = "test-subnetwork"
   access_config {
      # Leave empty for dynamic public IP
    }
  }  

}