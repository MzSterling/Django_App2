resource "aws_ecs_cluster" "main" {
  name = "media-analytics-cluster"
}

resource "aws_ecr_repository" "app" {
  name = "media-analytics-app"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "media-analytics-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "media-analytics-container"
    image     = "${aws_ecr_repository.app.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8000
      hostPort      = 8000
      protocol      = "tcp"
    }]
    environment = [
      { name = "DJANGO_SECRET_KEY", value = random_string.django_secret.result },
      { name = "DJANGO_ALLOWED_HOSTS", value = "*" }
    ]
  }])
}

resource "aws_ecs_service" "app" {
  name            = "media-analytics-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

/*
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  */

  network_configuration {
  subnets         = aws_subnet.public[*].id
  security_groups = [aws_security_group.ecs_sg.id]
  assign_public_ip = true
}

  

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "media-analytics-container"
    container_port   = 8000
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}
