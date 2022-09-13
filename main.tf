terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "sso-sandbox"
}

// Defining default network vpc resources for later references
resource "aws_default_vpc" "default_vpc" {

}
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-1a"
}
resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "eu-west-1c"
}

resource "aws_ecs_cluster" "ecs_cluster_demo" {
  name = "njtest-ecs-cluster"
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
  family                   = "ecs_task_demo"
  requires_compatibilities = var.capacity_providers
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  # Use jsonencode()?
  container_definitions = <<DEFINITION
    [
        {
            "name": "njtest_ecs_task_demo",
            "image": "docker.io/acantril/containerofcats",
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
  name            = "njtest-ecs-service-demo"
  cluster         = aws_ecs_cluster.ecs_cluster_demo.id
  task_definition = aws_ecs_task_definition.ecs_task_demo.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = var.capacity_providers[0]
    weight            = 1
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true
  }
}