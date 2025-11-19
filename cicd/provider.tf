terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.12.0"
    }
  }
  backend "s3" {
        bucket = "sainath-remote"
        key = "expense-dev-jenkins"
        region = "us-east-1"
        dynamodb_table = "sainath-locking"
    
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}