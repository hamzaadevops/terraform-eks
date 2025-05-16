module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  bootstrap_self_managed_addons = true

  # Optional: Enable the cluster endpoint public access
  cluster_endpoint_public_access = true
#   access_entries = {
#     example = {
#       principal_arn = "arn:aws:iam::123456789012:user/my-user"

#       policy_associations = {
#         example = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
#           access_scope = {
#             namespaces = ["default"]
#             type       = "namespace"
#           }
#         }
#       }
#     }
#   }

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions  = true
  cluster_enabled_log_types                 = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  enable_irsa = true

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    nodegroup-burstable = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = var.ami_type
      instance_types = var.instance_types

      min_size     = var.min_size
      desired_size = var.desired_size
      max_size     = var.max_size

      subnet_ids = var.subnet_ids
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}