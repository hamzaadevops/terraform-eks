terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"    # Pins to the v5 series, e.g. 5.0 ≤ v < 6.0
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.15"
    }
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "ap-south-1"
}
