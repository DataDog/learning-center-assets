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
  app_name                 = "domain-tester-service"
  app_task_definition_file = var.app_task_definition_file
  ddApiKey                 = var.ddApiKey
}

output "app_url" {
  value = module.ecs.app_url
}

output "vpc_id" {
  value = module.ecs.vpc_id
}
