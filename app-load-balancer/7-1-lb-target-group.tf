resource "aws_lb" "kwida_aps1" {
  name               = "${var.i_name_app}-aps1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_aps1.id]

  # access_logs {
  #   bucket  = "my-logs"
  #   prefix  = "my-app-lb"
  #   enabled = true
  # }

  subnets = [
    aws_subnet.public_ap_southeast_1a.id,
    aws_subnet.public_ap_southeast_1b.id
  ]
}

resource "aws_lb_listener" "http_aps1" {
  load_balancer_arn = aws_lb.kwida_aps1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kwida_asp1.arn
  }
}

resource "aws_lb_target_group" "kwida_asp1" {
  name       = "${var.i_name_app}-asp1"
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = aws_vpc.main.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 8081
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "kwida_aps1" {
  for_each = aws_instance.kwida

  target_group_arn = aws_lb_target_group.kwida_asp1.arn
  target_id        = each.value.id
  port             = 8080
}