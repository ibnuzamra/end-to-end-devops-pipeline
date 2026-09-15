output "cluster_name" { value = var.enabled ? module.this[0].cluster_name : null }
output "cluster_endpoint" { value = var.enabled ? module.this[0].cluster_endpoint : null }
output "cluster_arn" { value = var.enabled ? module.this[0].cluster_arn : null }

