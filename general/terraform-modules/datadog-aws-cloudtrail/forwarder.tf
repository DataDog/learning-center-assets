# Created a dedicated DD API key for the forwarder
resource "datadog_api_key" "cloudtrail" {
  name = "cloudtrail-tf-forwarder-${local.aws-account-id}-${local.random-suffix}"
}

resource "aws_secretsmanager_secret" "dd_api_key" {
  name                    = "datadog_cloudtrail_api_key"
  description             = "Datadog API Key for CloudTrail forwarding"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id     = aws_secretsmanager_secret.dd_api_key.id
  secret_string = datadog_api_key.cloudtrail.key
}

resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = "datadog-tf-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecretArn   = aws_secretsmanager_secret_version.dd_api_key.arn
    DdSite              = "datadoghq.com",
    FunctionName        = local.forwarder-lambda-name
    ReservedConcurrency = 0
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}

locals {
  forwarder-lambda-name = "datadog-tf-cloudtrail-forwarder"
  forwarder-lambda-arn  = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]
}

resource "null_resource" "delete-concurrency" {
  provisioner "local-exec" {
    command = "aws lambda delete-function-concurrency --function-name ${local.forwarder-lambda-name}"
  }
  depends_on = [aws_cloudformation_stack.datadog_forwarder]
}

// TODO aws lambda delete-function-concurrency --function-name datadog-tf-cloudtrail-forwarder
