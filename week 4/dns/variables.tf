variable "allowed_account_ids" {
  type        = list(string)
  description = "Set to the approved AWS account ID(s)."
}
variable "domain_name" {
  type    = string
  default = "shield-demo.com"
}
variable "record_name" {
  type    = string
  default = "app"
}
variable "primary_region" {
  type    = string
  default = "eu-north-1"
}
variable "primary_alb_dns_name" {
  type        = string
  description = "Actual primary ALB DNS name from compute stack."
}
variable "primary_alb_zone_id" {
  type        = string
  description = "Actual canonical hosted zone ID of primary ALB."
}
variable "standby_alb_dns_name" {
  type        = string
  description = "Actual standby ALB DNS name from compute stack."
}
variable "standby_alb_zone_id" {
  type        = string
  description = "Actual canonical hosted zone ID of standby ALB."
}
