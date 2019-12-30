provider "aws" {
  region  = "${var.aws_region}"
  profile = "shannon"
}

terraform {
  backend "s3" {
    bucket  = "shannon-website"
    key     = "shannon-website/terraform/terraform.tfstate"
    region  = "us-west-2"
    profile = "shannon"
  }
}
