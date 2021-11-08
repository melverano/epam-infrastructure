resource "aws_iam_role" "epam-eks-node" {
  name = "epam-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "epam-eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.epam-eks-node.name
}

resource "aws_iam_role_policy_attachment" "epam-eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.epam-eks-node.name
}

resource "aws_iam_role_policy_attachment" "epam-eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.epam-eks-node.name
}

resource "aws_iam_role_policy_attachment" "epam-eks-node-AmazonCloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.epam-eks-node.name
}

resource "aws_eks_node_group" "epam-eks-node-group" {
  cluster_name    = aws_eks_cluster.epam-eks.name
  node_group_name = "epam-eks-node-group"
  node_role_arn   = aws_iam_role.epam-eks-node.arn
  subnet_ids      = ["subnet-0f1a3293d2f69f257","subnet-0d86d430d25258a18"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.epam-eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.epam-eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.epam-eks-node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.epam-eks-node-AmazonCloudWatchFullAccess
  ]
}
