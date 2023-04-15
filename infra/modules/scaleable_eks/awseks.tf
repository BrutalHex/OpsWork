
resource "aws_eks_cluster" "eks" {
  name     = var.app_name
  role_arn = aws_iam_role.eks_direct_iam.arn

  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {

    subnet_ids = [for item in aws_subnet.eks : item.id]
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_policy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,

  ]
  tags = {
    Name = "${var.app_name}"
    env  = "${var.app_environment}_eks"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = "eks_auth"
}




resource "aws_iam_role" "eks_direct_iam" {
  name = "eks_direct_iam"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Name = "${var.app_name}_eks_direct_iam"
    env  = "${var.app_environment}_eks"
  }
}




resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_direct_iam.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_direct_iam.name
}






 