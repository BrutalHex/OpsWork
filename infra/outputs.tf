output "region" {
  value = var.aws_region
}
output "endpoint" {
  value = module.app-eks.endpoint
}
output "cluster_name" {
  value = module.app-eks.cluster_name
}

output "cluster_role" {
  value = module.app-eks.cluster_role
}