terraform {
  backend "s3" {
    bucket = "tfstate-test-1587434605699"
    key    = "test/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

variable "aws-region" {
  default = "ap-northeast-1"
}

provider "aws" {
  region = var.aws-region
}

data "aws_caller_identity" "current" {}
