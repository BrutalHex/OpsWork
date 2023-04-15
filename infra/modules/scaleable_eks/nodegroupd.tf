resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks"
  node_role_arn   = aws_iam_role.node_group_eks.arn
  subnet_ids      = [for item in aws_subnet.eks : item.id]
  instance_types  = ["t2.small"]
  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  depends_on = [
    aws_iam_role_policy_attachment.node_group_eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_eks_AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks.name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"                     = "true"
  }
}

resource "aws_iam_role" "node_group_eks" {
  name = "eks_node_group_eks"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"]
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}





resource "aws_iam_role_policy_attachment" "node_group_eks_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_eks.name
}

resource "aws_iam_role_policy_attachment" "node_group_eks_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_eks.name
}

resource "aws_iam_role_policy_attachment" "node_group_eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_eks.name
}


