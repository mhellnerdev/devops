provider "aws" {
  profile    = "default"
  region     = var.region
}

resource "aws_s3_bucket" "circlelabs-terraform-states" {
    bucket = "circlelabs-terraform-states"
    acl    = "private"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    tags = {
      Name = "S3 Remote Terraform State Store"
    }      
}