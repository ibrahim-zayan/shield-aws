provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = var.allowed_account_ids
  default_tags { tags = { Project = "shield-aws", Week = "4", ManagedBy = "Terraform" } }
}
