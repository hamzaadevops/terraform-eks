
variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}

variable "oidc_provider_arn" {
    description = "The oidc_provider_arn of the EKS cluster"
    type        = string
}

variable "cluster_oidc_issuer_url" {
    description = "The cluster_oidc_issuer_url of the EKS cluster"
    type        = string
}

output "iam_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_admin_role_arn" {
  value = aws_iam_role.eks_admin_role.arn
}

output "alb_irsa_role_arn" {
  value = aws_iam_role.alb_irsa_role.arn
}