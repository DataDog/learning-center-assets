

# Application
resource "aws_ecs_service" "app" {
  name = var.app_name

  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    container_name   = "main" # Note: The container must be named like this
    container_port   = 8000
    target_group_arn = aws_alb_target_group.backend.arn
  }

  # https://stackoverflow.com/questions/53971873/the-target-group-does-not-have-an-associated-load-balancer
  depends_on = [aws_alb_listener.http]

  # https://github.com/hashicorp/terraform-provider-aws/issues/22823#issuecomment-1118343091
  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  requires_compatibilities = ["EC2"]
  memory                   = var.app_max_memory
  container_definitions    = file(var.app_task_definition_file)
}
