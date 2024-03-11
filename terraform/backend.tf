terraform {
  backend "s3" {
    bucket = "tfstate-bucket-09032024"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}