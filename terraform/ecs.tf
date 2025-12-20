resource "aws_ecs_cluster" "main" {
  name = "gui13-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

locals {
  docker_image_uri = "${aws_ecr_repository.gui13.repository_url}:latest"
  log_group_name  = "/ecs/gui13-app"
}

resource "aws_cloudwatch_log_group" "app" {
  name              = local.log_group_name
  retention_in_days = 14
}

resource "aws_ecs_task_definition" "app" {
  family                   = "gui13-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "4096"
  
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  container_definitions    = jsonencode([
    {
      name  = "app"
      image = local.docker_image_uri
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "app"
        }
      }
      portMappings = [
        {
          containerPort = 3001
          hostPort      = 3001
          protocol      = "tcp"
        }
      ]
    }
  ])
  depends_on = [aws_ecr_repository.gui13]
}

resource "aws_iam_role" "ecs_execution" {
  name = "gui13-ecs-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
