variable "name" {
  description = "Name prefix for VPC and associated resources"
  type        = string
  default     = "project-vpc"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.72.0/22"
}

variable "azs" {
  description = "List of Availability Zones in the region"
  type        = list(string)
  default     = ["ap-southeast-3a", "ap-southeast-3b"]
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["172.16.72.0/26", "172.16.72.64/26"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private application subnets"
  type        = list(string)
  default     = ["172.16.74.0/26", "172.16.74.64/26"]
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT Gateway(s) for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to provision a single shared NAT Gateway across AZs to minimize cost"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
