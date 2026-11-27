variable "name" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(string)
  validation {
    condition     = length(var.azs) == 2
    error_message = "Provide exactly two AZs."
  }
}
variable "subnet_cidrs" {
  type = object({
    public   = list(string)
    app      = list(string)
    database = list(string)
  })
}
