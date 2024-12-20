# Output registry_id and repository_url for the winery_app ECR repository

output "registry_id" {
  value = aws_ecr_repository.winery_app.registry_id
}

output "repository_app_url" {
  value = aws_ecr_repository.winery_app.repository_url
}

output "repository_grafana_url" {
  value = aws_ecr_repository.grafana.repository_url
}

output "repository_prometheus_url" {
  value = aws_ecr_repository.prometheus.repository_url
}