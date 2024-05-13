variable "project" {
  type    = string
  default = "playground-s-11-2f44feb5"
}

variable "vpc_name" {
  type    = string
  default = "vpc-us-central1"
}

variable "subnet_name" {
  type    = string
  default = "vpc-us-central1-subnet"
}

variable "cidr_range" {
  type    = string
  default = "192.168.1.0/24"
}

variable "machine_name" {
  type    = string
  default = "demo"
}

variable "machine_image" {
  type    = string
  default = "projects/rhel-cloud/global/images/rhel-9-v20240415"
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}
