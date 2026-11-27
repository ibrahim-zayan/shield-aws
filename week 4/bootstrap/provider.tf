provider "aws" {
  region              = var.region
  allowed_account_ids = var.allowed_account_ids
  default_tags { tags = { Project = var.project, Week = "4", ManagedBy = "Terraform" } }
}
