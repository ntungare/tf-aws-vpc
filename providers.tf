terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  profile = "terraform"

  default_tags {
    tags = {
      env = "test"
    }
  }
}

data "aws_availability_zones" "available" {}
