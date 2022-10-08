terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.2.5"
}

provider "kubernetes" {
  config_path = "/home/daghan/.kube/config"
}

provider "aws" {
  region = var.aws_region
}