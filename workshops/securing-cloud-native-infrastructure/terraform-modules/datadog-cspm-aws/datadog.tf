locals {
}

resource "datadog_integration_aws" "aws-integration" {
  account_id                       = local.aws-account-id
  role_name                        = local.integration-role-name
  resource_collection_enabled      = true
  cspm_resource_collection_enabled = true
}