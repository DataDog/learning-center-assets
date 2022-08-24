variable "ddApiKey" {}


# Datadog agent
resource "aws_ecs_service" "datadog-agent" {
  name                = "datadog-agent"
  cluster             = module.ecs.cluster_id
  task_definition     = aws_ecs_task_definition.datadog-agent.arn
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON" # run once per EC2 instance
}

resource "aws_ecs_task_definition" "datadog-agent" {
  family                   = "datadog-agent-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  container_definitions = templatefile("./agent-task-containers.tftpl", {
    ddApiKey = var.ddApiKey
  })

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }

  volume {
    name      = "passwd"
    host_path = "/etc/passwd"
  }

  volume {
    name      = "pointdir"
    host_path = "/opt/datadog-agent/run"
  }
}


# Ecommerce app
resource "aws_ecs_service" "ecommerce-app" {
  name = "ecommerce-app"

  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.ecommerce-app.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    container_name   = "frontend"
    container_port   = 3000
    target_group_arn = aws_alb_target_group.ecommerce.arn
  }

  # https://stackoverflow.com/questions/53971873/the-target-group-does-not-have-an-associated-load-balancer
  depends_on = [aws_alb_listener.http]

  # https://github.com/hashicorp/terraform-provider-aws/issues/22823#issuecomment-1118343091
  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }
}

resource "random_password" "psql" {
  length  = 16
  special = false
}

resource "aws_ecs_task_definition" "ecommerce-app" {
  family                   = "ecommerce-app"
  requires_compatibilities = ["EC2"]
  memory                   = "1000"
  container_definitions = templatefile("./shop-containers.tftpl", {
    postgresqlPassword = random_password.psql.result,
  })
}
