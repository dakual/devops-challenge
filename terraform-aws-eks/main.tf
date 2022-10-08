# i am creating iam role for cluster
resource "aws_iam_role" "iam-role-redacre-cluster" {
  name = "redacre-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# i attach policy to my cluster role
resource "aws_iam_role_policy_attachment" "redacre-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.iam-role-redacre-cluster.name}"
}

# i attach policy to my cluster role
resource "aws_iam_role_policy_attachment" "redacre-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.iam-role-redacre-cluster.name}"
}

# i create security group for new cluster. i open all incoming and outging ports
resource "aws_security_group" "redacre-eks-cluster" {
  name        = "redacre-eks-cluster-sg"
  vpc_id      = "${var.vpc_id}"  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# creating eks cluster.
resource "aws_eks_cluster" "redacre-cluster" {
  name     = "redacre-cluster"
  role_arn = "${aws_iam_role.iam-role-redacre-cluster.arn}"
  version  = "1.22"

  vpc_config {
    security_group_ids = ["${aws_security_group.redacre-eks-cluster.id}"]
    subnet_ids         = var.vpc_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.redacre-eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.redacre-eks-cluster-AmazonEKSServicePolicy,
  ]
}

# i am creatig iam role for cluster nodes
resource "aws_iam_role" "redacre_eks_nodes" {
  name = "redacre-eks-node-group"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# i attach node policy to my node role
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.redacre_eks_nodes.name
}

# i attach container network interface policy to my node role
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.redacre_eks_nodes.name
}

# i attach registry policy to my node role
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.redacre_eks_nodes.name
}

# creating node group and adding linux nodes
resource "aws_eks_node_group" "redacre-node" {
  cluster_name    = aws_eks_cluster.redacre-cluster.name
  node_group_name = "redacre-node-group-1"
  node_role_arn   = aws_iam_role.redacre_eks_nodes.arn
  subnet_ids      = var.vpc_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t2.micro"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 10

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}