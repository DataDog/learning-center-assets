locals {
  datadog-aws-account-id = "464622532012" # from  https://docs.datadoghq.com/integrations/amazon_web_services/?tab=roledelegation#setup
}

data "aws_iam_policy_document" "trust-policy" {
  statement {
    sid     = "AllowAssumeRoleFromDatadog"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [local.datadog-aws-account-id]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [datadog_integration_aws.aws-integration.external_id]
    }
  }
}

resource "aws_iam_role" "datadog-role" {
  name               = local.integration-role-name
  assume_role_policy = data.aws_iam_policy_document.trust-policy.json
}

resource "aws_iam_role_policy_attachment" "security-audit" {
  role       = aws_iam_role.datadog-role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Additional permissions required for CSPM
# c.f. https://docs.datadoghq.com/integrations/amazon_web_services/#aws-integration-iam-policy
resource "aws_iam_policy" "additional-permissions" {
  name   = "datadog-integration-policy"
  policy = file("${path.module}/datadog-integration-policy.json")
}

resource "aws_iam_role_policy_attachment" "additional-permissions" {
  role       = aws_iam_role.datadog-role.name
  policy_arn = aws_iam_policy.additional-permissions.arn
}
