data "aws_caller_identity" "current" {}

locals {
  aws-account-id        = data.aws_caller_identity.current.account_id
  integration-role-name = "DatadogAWSIntegrationRole"
}