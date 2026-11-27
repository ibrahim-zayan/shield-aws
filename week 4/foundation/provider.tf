provider "aws" {
  region              = var.primary_region
  allowed_account_ids = var.allowed_account_ids
  default_tags { tags = { Project = var.project, Week = "4", ManagedBy = "Terraform" } }
}

provider "aws" {
  alias               = "standby"
  region              = var.standby_region
  allowed_account_ids = var.allowed_account_ids
  default_tags { tags = { Project = var.project, Week = "4", Environment = "standby", ManagedBy = "Terraform" } }
}
