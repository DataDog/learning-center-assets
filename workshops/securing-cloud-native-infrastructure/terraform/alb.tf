resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol         = "tcp"
    description      = "Allow HTTP ingress"
    from_port        = 3000
    to_port          = 3000
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    description      = "Allow egress"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "ecommerce" {
  name                       = "ecommerce-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "ecommerce" {
  name                 = "ecommerce-tg"
  port                 = 3000
  protocol             = "HTTP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "instance"
  deregistration_delay = 10

  health_check {
    enabled             = true
    port                = 3000
    interval            = 120
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/"
    timeout             = 119
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.ecommerce.id
  port              = 3000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecommerce.id
    type             = "forward"
  }
}

output "app_url" {
  value = format("http://%s:3000", aws_lb.ecommerce.dns_name)
}
