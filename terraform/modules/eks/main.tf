module "this" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  count   = var.enabled ? 1 : 0

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  enable_irsa     = true
  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }
  }
  tags = var.tags
}

