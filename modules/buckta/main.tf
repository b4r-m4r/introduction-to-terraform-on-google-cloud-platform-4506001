module "cloud-storage" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "6.0.1"
  names   = ["${var.project_name}-bucket"]
  project_id = "${var.project_name}"
}


resource "google_storage_bucket_object" "uno" {
  name = "index.html"
  source = "./index.html"
  content_type = "text/plain"
  bucket = module.cloud-storage.names_list[0]
}