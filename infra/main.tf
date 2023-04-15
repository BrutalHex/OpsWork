module "app-eks" {
  source          = "./modules/scaleable_eks"
  app_environment = var.app_environment
  aws_region      = var.aws_region
  aws_profile     = var.aws_profile
  vpc_cidrblock   = var.vpc_cidrblock
  app_name        = var.app_name
}


