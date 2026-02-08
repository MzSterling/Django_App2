output "alb_dns" {
  value = aws_lb.app.dns_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}

output "django_secret" {
  value = random_string.django_secret.result
}
