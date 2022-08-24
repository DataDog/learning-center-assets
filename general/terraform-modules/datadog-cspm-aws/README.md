# Datadog CSPM + AWS (Terraform)

This module configures the Datadog AWS integration to use with the CSPM product.

## Usage

First, make sure you're authenticated against your AWS account and have `DATADOG_API_KEY` and `DATADOG_APP_KEY` set. Then run:

```
terraform apply
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.8.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | 3.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.8.0 |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 3.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.datadog-role](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.security-audit](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/iam_role_policy_attachment) | resource |
| [datadog_integration_aws.aws-integration](https://registry.terraform.io/providers/DataDog/datadog/3.10.0/docs/resources/integration_aws) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.trust-policy](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | n/a | `any` | n/a | yes |
| <a name="input_dd_app_key"></a> [dd\_app\_key](#input\_dd\_app\_key) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
