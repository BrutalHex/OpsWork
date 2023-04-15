variable "app_environment" {
  default = "dev"
}
variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_profile" {
  default = "default"
}
variable "vpc_cidrblock" {
  description = "the cidr block of vpc"
  type        = string
}
variable "app_name" {
  type    = string
  default = "app_systems"
}
variable "az_number" {
  default = {
    a = 1,
    b = 2
  }
}