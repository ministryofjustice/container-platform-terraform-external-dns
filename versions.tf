terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.4.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.14.0"
    }
  }
  required_version = "~> 1.0"
}