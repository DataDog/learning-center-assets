module "cspm" {
  source = "../../../general/terraform-modules/datadog-cspm-aws"
}

module "cloudtrail" {
  source = "../../../general/terraform-modules/datadog-aws-cloudtrail"
}

module "ecs" {
  source = "../aws-ecs-cluster"

  cluster_name      = "prod-cluster"
  worker_node_count = 1
}
