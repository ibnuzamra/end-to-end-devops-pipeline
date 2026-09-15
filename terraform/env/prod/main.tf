terraform {
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }
data "aws_vpc" "staging" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.staging.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["false"]
  }
}
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
module "ec2" {
  source           = "../../modules/ec2"
  name             = "free-tier-prod"
  vpc_id           = data.aws_vpc.staging.id
  subnet_id        = data.aws_subnets.default.ids[0]
  ami_id           = data.aws_ami.al2023.id
  instance_type    = var.instance_type
  ssh_ingress_cidr = var.ssh_ingress_cidr
  tags             = { Environment = "prod", ManagedBy = "terraform" }
}
