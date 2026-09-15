variable "zone_name" { type = string }
variable "records" {
  type    = map(object({ type = string, ttl = number, records = list(string) }))
  default = {}
}

