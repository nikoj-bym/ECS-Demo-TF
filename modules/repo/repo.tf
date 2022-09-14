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

// Creating a new repository for my images
resource "aws_ecr_repository" "my_first_ecr_repo" {
  name = "njtest-ecr-repo"
}

# resource "aws_ecr_repository_policy" "demo-repo-policy" {
#   repository = aws_ecr_repository.my_first_ecr_repo.name
#   policy     = <<EOF
#   {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid": "adds full ecr access to the demo repository",
#         "Effect": "Allow",
#         "Principal": "*",
#         "Action": [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:CompleteLayerUpload",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetLifecyclePolicy",
#           "ecr:InitiateLayerUpload",
#           "ecr:PutImage",
#           "ecr:UploadLayerPart"
#         ]
#       }
#     ]
#   }
#   EOF
# }