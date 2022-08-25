module "cspm" {
  source = "../../../general/terraform-modules/datadog-cspm-aws"
}

module "cloudtrail" {
  source = "../../../general/terraform-modules/datadog-aws-cloudtrail"
}

module "ecs" {
  source = "../aws-ecs-cluster"

  cluster_name             = "prod-cluster"
  worker_node_count        = 1
  app_name                 = "sample-vulnerable-java-application"
  app_ecr_url              = var.app_ecr_url
  app_task_definition_file = var.app_task_definition_file
  ddApiKey                 = var.ddApiKey
}
