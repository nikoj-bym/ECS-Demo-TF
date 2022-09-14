
resource "aws_ecs_cluster" "ecs_cluster_demo" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cap_demo" {
  cluster_name = aws_ecs_cluster.ecs_cluster_demo.name

  capacity_providers = var.capacity_providers

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = var.capacity_providers[0]
  }
}

resource "aws_ecs_task_definition" "ecs_task_demo" {
  family                   = var.task_name
  requires_compatibilities = var.capacity_providers
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = "arn:aws:iam::224175832146:role/ecsTaskExecutionRole"

  # Use jsonencode()?
  container_definitions = <<DEFINITION
    [
        {
            "name": "njtest_ecs_task_demo",
            "image": "${var.container_image}",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80
                }
            ],
            "memory": 512
        }
    ]
    DEFINITION
}

resource "aws_ecs_service" "ecs_service_demo" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs_cluster_demo.id
  task_definition = aws_ecs_task_definition.ecs_task_demo.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = var.capacity_providers[0]
    weight            = 1
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
  }
}