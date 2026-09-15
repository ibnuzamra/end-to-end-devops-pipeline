data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = var.trusted_services
    }
  }
}
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags               = var.tags
}
data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "EcrPullPush"
    actions   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:BatchGetImage", "ecr:CompleteLayerUpload", "ecr:InitiateLayerUpload", "ecr:PutImage", "ecr:UploadLayerPart", "ecr:DescribeRepositories", "ecr:ListImages", "ecr:DescribeImages"]
    resources = ["*"]
  }
  statement {
    sid       = "InspectorReadAndScan"
    actions   = ["inspector2:BatchGetAccountStatus", "inspector2:BatchGetFindings", "inspector2:ListFindings", "inspector2:ListCoverage", "inspector2:ListCoverageStatistics", "inspector2:Enable", "inspector2:Disable"]
    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "this" {
  name   = "${var.role_name}-ecr-inspector"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.permissions.json
}
