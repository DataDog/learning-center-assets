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
  container_definitions = templatefile("${path.module}/templates/datadog-agent-task.tftpl", {
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
    host_path = "/sys/fs/cgroup/"
  }


  volume {
    name      = "kerneldebug"
    host_path = "/sys/kernel/debug"
  }

  volume {
    name      = "passwd"
    host_path = "/etc/passwd"
  }

  volume {
    name      = "group"
    host_path = "/etc/group"
  }

  volume {
    name      = "host"
    host_path = "/"
  }

  volume {
    # NOTE: In the container we mount on /host/sys/kernel/security because of this error message:
    # 	* /host/sys/kernel/security doesn't seem to be a mountpoint
    name      = "kernelsecurity"
    host_path = "/sys/kernel/security"
  }

  volume {
    name      = "osrelease"
    host_path = "/etc/os-release"
  }

  volume { # unused for now
    name      = "pointdir"
    host_path = "/opt/datadog-agent/run"
  }
}
