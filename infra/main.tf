terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }

  # COMMENT THIS OUT IF YOU WISH TO RUN PROGRAM- OR change bucket/table names to your bucket and table backend!
    backend "s3" {
    
    bucket         = "rmit-tfstate-48ub2c"
    key            = "assignment-2/infra-deployment/terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "rmit-locktable-48ub2c"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# latest free tier Amazon linux 2 machine
data "aws_ami" "amazon-2" {
 most_recent = true
 owners = ["amazon"]


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-kernel*"]
 }

 filter {
   name = "architecture"
   values = ["x86_64"]
 
 }
 filter {
   name = "virtualization-type"
   values = ["hvm"]
 }
}