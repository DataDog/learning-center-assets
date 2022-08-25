# Notes: These variables are defined here to be propagated to the ECS module
variable "ddApiKey" {
  type        = string
  description = "Datadog API key to use in the ECS cluster for the agent"
}

variable "app_ecr_url" {
  type        = string
  description = "ECR URL of the application to deploy to the cluster"
}

variable "app_task_definition_file" {
  type        = string
  description = "Path to the application ECS task definition file"
}
