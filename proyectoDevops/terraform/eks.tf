module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  version         = "19.16.0"
  cluster_version = "1.27"
  subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  vpc_id = aws_vpc.my_vpc.id

   eks_managed_node_groups = {
    eks_nodes = {
      instance_type      = "t2.micro"
      desired_capacity   = 2
      min_capacity       = 1
      max_capacity       = 3
      subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    }
  }
}