# Fetch your current AWS account ID
data "aws_caller_identity" "current" {}

# The role that you want people to assume
resource "aws_iam_role" "eks_access_to_iam" {
  name = "eks_access_to_iam"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          # Trust your whole account—actual gatekeeping is in the group policy below
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AmazonEKSClusterPolicy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_access_to_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create an IAM Group Administrators 
resource "aws_iam_group" "administrators" {
  name = "Administrators"
}

# Allow the group to assume the EKS role
#    So only members of Administrators can actually call sts:AssumeRole on eks_access_to_iam
resource "aws_iam_group_policy" "allow_assume_eks_access" {
  name  = "AllowAssumeEksAccess"
  group = aws_iam_group.administrators.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.eks_access_to_iam.arn
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
