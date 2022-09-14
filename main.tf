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

module "networking" {
  source = "./modules/networking"
}

# module "repo" {
#   source = "./modules/repo"
# }


// Retrieving container image from sandbox ECR
# data "aws_ecr_image" "my_image" {
#   repository_name = module.repo.repo_name
#   image_tag       = "latest" #?
# }

module "ecs" {
  source             = "./modules/ecs"
  capacity_providers = ["FARGATE"]
  cluster_name       = "njtest-ecs-cluster"
  task_name          = "njtest-ecs-task-demo"
  subnets            = module.networking.subnets
  cpu                = 256
  memory             = 512
  network_mode       = "awsvpc"
  service_name       = "njtest-ecs-service-demo"
  container_image    = "224175832146.dkr.ecr.eu-west-1.amazonaws.com/njtest-ecr-repo:latest"
}
