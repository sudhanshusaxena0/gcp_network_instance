terraform {
  #required_version = ">= 1.0.11"
  required_providers {
    google = {
  #    version = ">= 4.25.0"
      source  = "hashicorp/google"
    }
  }
  backend "remote" {
  # The name of your Terraform Cloud organization.
    organization = "terraform_cloud_org00"

  # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "terraform_cloud_workspace"
    }
  }
}
