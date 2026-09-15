variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "ssh_ingress_cidr" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
