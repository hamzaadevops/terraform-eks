# Fetch your current AWS account ID
data "aws_caller_identity" "current" {}
  # ─────────────────────────────────────────────────────────────────────
  #                     AWS IAM ROLE
  # ─────────────────────────────────────────────────────────────────────
resource "aws_iam_role" "eks_admin_role" {
  name = "eks_admin_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
  # ─────────────────────────────────────────────────────────────────────
  #                     ROLE POLICY ATTACHMENT
  # ─────────────────────────────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_nodes"{
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}

# ensure Terraform owns all the managed policy attachments and deletes anything not declared

# resource "aws_iam_role_policy_attachments_exclusive" "eks_node_role_policies" {
#   role = aws_iam_role.eks_node_role.name
#   policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#     "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   ]
# }

  # ─────────────────────────────────────────────────────────────────────
  #                     IAM USERS Related Stuff
  # ─────────────────────────────────────────────────────────────────────
resource "aws_iam_group" "administrators" {
  name = "Administrators"
}

# Allow the group to assume the EKS role
#    So only members of Administrators can actually call sts:AssumeRole on eks_admin_role
resource "aws_iam_group_policy" "allow_assume_eks_access" {
  name  = "AllowAssumeEksAccess"
  group = aws_iam_group.administrators.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.eks_admin_role.arn
      }
    ]
  })
}

# Create a user 
resource "aws_iam_user" "alice" {
  name = "alice"
}

# Add the user to the Administrators group
resource "aws_iam_user_group_membership" "alice_admin" {
  user = aws_iam_user.alice.name
  groups = [
    aws_iam_group.administrators.name
  ]
}

# ✅ This ensures that the role itself has permission to call eks:DescribeCluster after it has been assumed by your user/group.
resource "aws_iam_role_policy" "eks_access_inline_policy" {
  name = "AllowEksDescribeCluster"
  role = aws_iam_role.eks_admin_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*"
        ]
        Resource = "*"
      }
    ]
  })
}
