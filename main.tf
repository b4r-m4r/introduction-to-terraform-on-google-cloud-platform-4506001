terraform {
  cloud {
    organization = "tf-gcp-intrto"
    workspaces {
      name = "introduction-to-terraform-on-google-cloud-platform-4506001"
    }
  }
}

module "nfs-test" {
  source = "./modules/buckta"
}

module "bar_network" {
  source  = "terraform-google-modules/network/google"
  version = "9.1.0"
  network_name = "${var.network_name}-ab"
  project_id = var.project_name
  subnets = [
        {
            subnet_name = "${var.network_name}-sub0"
            subnet_ip = var.network_range
            subnet_region = var.region
        }
  ]

  ingress_rules = [
    {
    name = "${var.network_name}--allow-bar"
    description = "Inbound ingress test"
    source_ranges = ["46.116.120.138/32"]
    target_tags = ["${var.network_name}--allow-bar-all"]

    allow = [
      {
        protocol = "tcp"
        ports    = ["1-65535"]
      }
    ]

    }
  ]
}

resource "google_compute_network" "tf-gcp" {
  name                    = var.network_name
}

resource "google_compute_subnetwork" "tf-gcp-t" {
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

  tags = ["${var.network_name}--bar"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
   subnetwork = module.bar_network.subnets_names[0]
   access_config {
      # Leave empty for dynamic public IP
    }
  }  

metadata_startup_script = "apt update; apt install nginx; echo ${var.app_name} > /var/www/html/index.html"

}