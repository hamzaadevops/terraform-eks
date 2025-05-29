output "cluster_name" {
  value = module.eks.cluster_name
}

output "node_group_arn" {
  value = module.eks.eks_managed_node_groups["nodegroup-burstable"].node_group_arn
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}