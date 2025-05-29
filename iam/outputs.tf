output "iam_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_admin_role_arn" {
  value = aws_iam_role.eks_admin_role.arn
}
