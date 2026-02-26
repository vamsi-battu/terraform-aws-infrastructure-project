terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    region         = "us-east-1"
    bucket         = "terraform-state-expense"
    key            = "expense-dev-rds"
    dynamodb_table = "terraform-locks"

  }
}

provider "aws" {
  region = "us-east-1"
}