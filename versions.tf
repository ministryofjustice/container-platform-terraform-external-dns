terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.4.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
  }
  required_version = "~> 1.0"
}