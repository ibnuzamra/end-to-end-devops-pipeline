variable "aws_region" {
  type    = string
  default = "ap-southeast-3"
}
variable "vpc_name" {
  type    = string
  default = "project-vpc"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "ssh_ingress_cidr" {
  type    = list(string)
  default = []
}
