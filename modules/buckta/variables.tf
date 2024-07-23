variable "project_name" {
    type = string
    default = "intense-wavelet-429717-f9"
}

variable "region" {
    type = string
    default = "europe-west2"
}

variable "app_name" {
    type = string
    default = "bartf"
}

variable "network_name" {
    type = string
    default = "tfgcp-nettest"
}   

variable "network_range" {
    type = string
    default = "10.2.0.0/16"
}
variable "image_project" {
    type = string
    default = "ubuntu-os-cloud"
}

variable "image_family" {
    type = string
    default = "ubuntu-2204-lts"
}

variable "machine_type" {
    type = string
    default = "e2-micro"
}
