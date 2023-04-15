variable "app_environment" {}
variable "aws_region" {}

variable "aws_profile" {}
variable "vpc_cidrblock" {
  description = "the cidr block of vpc"
  type        = string
}
variable "app_name" {

  type = string
}