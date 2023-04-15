data "aws_availability_zones" "available" {
  state = "available"
}




resource "aws_subnet" "eks" {
  for_each = var.az_number
  vpc_id   = aws_vpc.eks.id

  cidr_block = cidrsubnet(aws_vpc.eks.cidr_block, 4, each.value)


  availability_zone       = data.aws_availability_zones.available.names[each.value - 1]
  map_public_ip_on_launch = true
  tags = {
    Name                              = "${var.app_name}_eks"
    env                               = "${var.app_environment}_eks"
    "kubernetes.io/role/elb"          = 1
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_route_table_association" "eks" {
  for_each       = aws_subnet.eks
  subnet_id      = each.value.id
  route_table_id = aws_route_table.eks.id
}


 