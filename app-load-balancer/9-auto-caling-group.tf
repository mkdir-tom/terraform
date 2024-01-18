resource "aws_security_group" "ec2_aps2" {
  name   = "${var.i_name_app}-ec2-asp2"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "alb_aps2" {
  name   = "${var.i_name_app}alb-aps2"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_ec2_aps2_traffic" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_aps2.id
  source_security_group_id = aws_security_group.alb_aps2.id
}

resource "aws_security_group_rule" "ingress_ec2_aps2_health_check" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_aps2.id
  source_security_group_id = aws_security_group.alb_aps2.id
}

resource "aws_security_group_rule" "ingress_alb_aps2_http_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_aps2.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_aps2_https_traffic" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_aps2.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_aps2_traffic" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_aps2.id
  source_security_group_id = aws_security_group.ec2_aps2.id
}

resource "aws_security_group_rule" "egress_alb_aps2_health_check" {
  type                     = "egress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_aps2.id
  source_security_group_id = aws_security_group.ec2_aps2.id
}

resource "aws_launch_template" "my_app_eg2" {
  name                   = "${var.i_name_app}-eg2"
  image_id               = var.i_ec2.ami
  key_name               = var.i_ec2.key_name
  vpc_security_group_ids = [aws_security_group.ec2_aps2.id]
}

resource "aws_lb_target_group" "my_app_aps2" {
  name     = "${var.i_name_app}-eg2"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

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

resource "aws_autoscaling_group" "my_app_aps2" {
  name     = "${var.i_name_app}-eg2"
  min_size = 1
  max_size = 3

  health_check_type = "EC2"

  vpc_zone_identifier = [
    aws_subnet.private_ap_southeast_1a.id,
    aws_subnet.private_ap_southeast_1b.id
  ]

  target_group_arns = [aws_lb_target_group.my_app_aps2.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.my_app_eg2.id
      }
      override {
        instance_type = "t2.micro"
      }
    }
  }
}

resource "aws_autoscaling_policy" "my_app_aps2" {
  name                   = "my-app-eg2"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.my_app_aps2.name

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 25.0
  }
}

resource "aws_lb" "my_app_aps2" {
  name               = "${var.i_name_app}-eg2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_aps2.id]

  subnets = [
    aws_subnet.public_ap_southeast_1a.id,
    aws_subnet.public_ap_southeast_1b.id
  ]
}

resource "aws_lb_listener" "my_app_aps2" {
  load_balancer_arn = aws_lb.my_app_aps2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_aps2.arn
  }
}