output "repo_name" {
  description = "Name of the test ECR Repository"
  value       = aws_ecr_repository.my_first_ecr_repo.name
}

output "repo_url" {
  description = "URL of the test ECR Repository"
  value       = aws_ecr_repository.my_first_ecr_repo.repository_url
}