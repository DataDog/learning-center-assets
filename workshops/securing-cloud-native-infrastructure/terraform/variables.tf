# Notes: These variables are defined here to be propagated to the ECS module
variable "ddApiKey" {
  type        = string
  description = "Datadog API key to use in the ECS cluster for the agent"
}

variable "app_task_definition_file" {
  type        = string
  description = "Path to the application ECS task definition file"
}

variable "ecs_capacity_provider_name" {
  type = string
}