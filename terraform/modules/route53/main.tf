resource "aws_route53_zone" "this" { name = var.zone_name }
resource "aws_route53_record" "this" {
  for_each = var.records
  zone_id  = aws_route53_zone.this.zone_id
  name     = each.key
  type     = each.value.type
  ttl      = each.value.ttl
  records  = each.value.records
}

