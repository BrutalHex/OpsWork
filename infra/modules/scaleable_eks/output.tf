
output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.eks.name
}
output "cluster_role" {
  description = "Kubernetes Cluster role for auto discovery"
  value       = aws_iam_role.cluster_autoscaler.arn
}
