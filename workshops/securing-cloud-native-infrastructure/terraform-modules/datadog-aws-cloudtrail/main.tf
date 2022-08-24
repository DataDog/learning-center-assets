
resource "random_string" "suffix" {
  length    = 8
  min_lower = 8
}

data "aws_caller_identity" "current" {}

locals {
  aws-account-id = data.aws_caller_identity.current.account_id
  random-suffix  = random_string.suffix.result
}
