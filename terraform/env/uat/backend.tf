terraform {
  backend "s3" {
    bucket         = "project-terraform-state"
    key            = "ec2/uat/terraform.tfstate"
    region         = "ap-southeast-3"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
