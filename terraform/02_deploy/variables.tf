variable "registry_id" {
  description = "The registry id of the ECR repository"
  type        = string
}

variable "repository_app_url" {
  description = "The URL of the app ECR repository"
  type        = string
}

variable "repository_grafana_url" {
  description = "The URL of the Grafana ECR repository"
  type        = string
}

variable "repository_prometheus_url" {
  description = "The URL of the Prometheus ECR repository"
  type        = string
}

variable "GF_SECURITY_ADMIN_USER" {
  description = "The Grafana admin user"
  type        = string
  default     = "admin"
}

variable "GF_SECURITY_ADMIN_PASSWORD" {
  description = "The Grafana admin password"
  type        = string
  sensitive   = true
  default     = "grafana"
}