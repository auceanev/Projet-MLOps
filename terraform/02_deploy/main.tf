resource "aws_apprunner_service" "winnery_app" {
  service_name = "winnery-app"

  source_configuration {
    image_repository {
      image_configuration {
        port                          = "5000"
        runtime_environment_secrets   = {}
        runtime_environment_variables = {}
      }
      image_identifier      = "${var.repository_app_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true

    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_role.arn
    }
  }

  health_check_configuration {
    healthy_threshold   = 1
    interval            = 5
    path                = "/"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 5
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }

    egress_configuration {
      egress_type = "DEFAULT"
    }
  }

  instance_configuration {
    cpu    = "256"
    memory = "512"
  }
}

resource "aws_apprunner_service" "grafana" {
  service_name = "grafana"

  source_configuration {
    image_repository {
      image_configuration {
        port = "3000"
        runtime_environment_secrets = {}
        runtime_environment_variables = {
          GF_SECURITY_ADMIN_USER     = var.GF_SECURITY_ADMIN_USER
          GF_SECURITY_ADMIN_PASSWORD = var.GF_SECURITY_ADMIN_PASSWORD
          }
      }
      image_identifier      = "${var.repository_grafana_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true

    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_role.arn
    }
  }

  health_check_configuration {
    healthy_threshold   = 1
    interval            = 5
    path                = "/"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 5
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }

    egress_configuration {
      egress_type = "DEFAULT"
    }
  }

  instance_configuration {
    cpu    = "256"
    memory = "512"
  }
}

resource "aws_apprunner_service" "prometheus" {
  service_name = "prometheus"

  source_configuration {
    image_repository {
      image_configuration {
        port                          = "9090"
        runtime_environment_secrets   = {}
        runtime_environment_variables = {}
      }
      image_identifier      = "${var.repository_prometheus_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true

    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_role.arn
    }
  }

  health_check_configuration {
    healthy_threshold   = 1
    interval            = 5
    path                = "/"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 5
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }

    egress_configuration {
      egress_type = "DEFAULT"
    }
  }

  instance_configuration {
    cpu    = "256"
    memory = "512"
  }
}

