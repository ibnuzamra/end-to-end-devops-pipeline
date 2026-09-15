variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "subnet_id" { type = string }
variable "vpc_id" { type = string }
variable "ssh_ingress_cidr" {
  type    = list(string)
  default = []
}
variable "gitlab_external_url" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
