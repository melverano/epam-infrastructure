resource "aws_iam_role" "epam-eks-cluster" {
  name = "epam-eks-cluster"

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
}

resource "aws_iam_role_policy_attachment" "epam-eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.epam-eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "epam-eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.epam-eks-cluster.name
}

resource "aws_security_group" "epam-eks-sg" {
  name        = "epam-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "vpc-0b9ccc12a6e5a6bf4"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "epam-eks"
  }
}

resource "aws_security_group_rule" "epam-eks-ingress-workstation-https" {
  cidr_blocks       = ["10.0.0.0/16"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.epam-eks-sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "epam-eks" {
  name     = var.cluster-name
  role_arn = aws_iam_role.epam-eks-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.epam-eks-sg.id]
    subnet_ids         = ["subnet-0f1a3293d2f69f257","subnet-0d86d430d25258a18"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.epam-eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.epam-eks-AmazonEKSVPCResourceController,
  ]
}
