output "cluster_name" {
  value = module.eks.cluster_name
}

output "node_group_arn" {
  value = module.eks.eks_managed_node_groups["nodegroup-burstable"].node_group_arn
}
