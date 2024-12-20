provider "aws" {
  # Configuration options

  default_tags {
    tags = {
      "Terraform" = "true"
      "Project"   = "ML-Ops"
    }
  }
}