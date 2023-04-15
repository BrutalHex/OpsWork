resource "aws_vpc" "eks" {
  cidr_block = var.vpc_cidrblock

  tags = {
    Name = "${var.app_name}_eks_VPC"
    env  = "${var.app_environment}_eks"
  }

}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id
  tags = {
    Name = "${var.app_name}_eks"
    env  = "${var.app_environment}_eks"
  }
}

resource "aws_route_table" "eks" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }
  tags = {
    Name = "${var.app_name}_eks"
    env  = "${var.app_environment}_eks"
  }
}





resource "aws_security_group" "eks" {
  vpc_id = aws_vpc.eks.id
  tags = {
    Name = "${var.app_name}_eks"
    env  = "${var.app_environment}_eks"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

