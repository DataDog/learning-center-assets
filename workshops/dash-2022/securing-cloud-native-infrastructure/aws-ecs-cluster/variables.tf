variable "ddApiKey" {
  type        = string
  description = "Datadog API key to use in the ECS cluster for the agent"
}

variable "cluster_name" {
  type = string
}

variable "app_name" {
  type        = string
  description = "Name of the application to deploy on ECS"
}

variable "app_task_definition_file" {
  type        = string
  description = "Path to the application ECS task definition file"
}

variable "app_max_memory" {
  type        = string
  default     = "3000"
  description = "Maximal app memory"
}

variable "worker_node_instance_type" {
  type        = string
  description = "Instance type to use for the underlying ECS EC2 instances"
  default     = "t2.medium"
}

variable "worker_node_count" {
  type        = number
  description = "Number of ECS EC2 worker instances to use"
  default     = 1
}

variable "ecs_capacity_provider_name" {
  type = string
}