variable "project" {
  type    = string
  default = "shield-aws"
}
variable "allowed_account_ids" {
  type        = list(string)
  description = "Set to the approved AWS account ID(s)."
}
variable "primary_region" {
  type    = string
  default = "eu-north-1"
}
variable "standby_region" {
  type    = string
  default = "eu-west-1"
}
variable "primary_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "standby_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
variable "primary_azs" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b"]
}
variable "standby_azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "primary_subnet_cidrs" {
  type = object({
    public   = list(string)
    app      = list(string)
    database = list(string)
  })
  default = {
    public   = ["10.0.1.0/24", "10.0.2.0/24"]
    app      = ["10.0.11.0/24", "10.0.12.0/24"]
    database = ["10.0.21.0/24", "10.0.22.0/24"]
  }
}
variable "standby_subnet_cidrs" {
  type = object({
    public   = list(string)
    app      = list(string)
    database = list(string)
  })
  default = {
    public   = ["10.1.1.0/24", "10.1.2.0/24"]
    app      = ["10.1.11.0/24", "10.1.12.0/24"]
    database = ["10.1.21.0/24", "10.1.22.0/24"]
  }
}
variable "ec2_ssm_role_name" {
  type    = string
  default = "Shield-EC2-SSM-Role"
}
