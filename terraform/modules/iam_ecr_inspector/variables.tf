variable "role_name" { type = string }
variable "trusted_services" {
  type    = list(string)
  default = ["ec2.amazonaws.com", "eks.amazonaws.com"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
