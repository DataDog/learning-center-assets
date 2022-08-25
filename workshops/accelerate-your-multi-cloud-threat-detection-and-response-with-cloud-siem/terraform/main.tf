module "cspm" {
  source = "../../../general/terraform-modules/datadog-cspm-aws"
}

module "cloudtrail" {
  source = "../../../general/terraform-modules/datadog-aws-cloudtrail"
}
