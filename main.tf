resource "google_compute_network" "tf-gcp" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf-gcp" {
  name          = var.network_name
  ip_cidr_range = var.network_range
  region        = var.region
  network       = google_compute_network.tf-gcp.id
}

data "google_compute_image" "ubuntu" {
  most_recent = true
  project     = var.image_project
  family      = var.image_family
}

resource "google_compute_instance" "web" {
  name         = var.app_name
  machine_type = var.machine_type

  
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
   subnetwork = var.network_name
   access_config {
      # Leave empty for dynamic public IP
    }
  }  

}