variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "allowed_account_ids" {
  type        = list(string)
  description = "Set to the approved AWS account ID(s)."
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state."
}

variable "project" {
  type    = string
  default = "shield-aws"
}
