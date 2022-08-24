# Datadog Cloud SIEM + CloudTrail logs

Run this module against a Datadog and AWS account; it will create a CloudTrail trail and the required forwarder to ship the logs to Datadog.

It should work even if another Datadog forwarder is deployed in the AWS account (possibly shipping logs somewhere else).
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.18.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | 3.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.18.0 |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 3.12.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.datadog_forwarder](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/cloudformation_stack) | resource |
| [aws_cloudtrail.trail](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/cloudtrail) | resource |
| [aws_lambda_permission.allow_bucket](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.cloudtrail-bucket](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.cloudtrail-bucket](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/s3_bucket_policy) | resource |
| [aws_secretsmanager_secret.dd_api_key](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.dd_api_key](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/resources/secretsmanager_secret_version) | resource |
| [datadog_api_key.cloudtrail](https://registry.terraform.io/providers/DataDog/datadog/3.12.0/docs/resources/api_key) | resource |
| [null_resource.delete-concurrency](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.18.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable-cloudtrail-data-events"></a> [enable-cloudtrail-data-events](#input\_enable-cloudtrail-data-events) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_a"></a> [a](#output\_a) | n/a |
<!-- END_TF_DOCS -->