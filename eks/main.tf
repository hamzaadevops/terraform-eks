module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # ─────────────────────────────────────────────────────────────────────
  #                     addons installation
  # ─────────────────────────────────────────────────────────────────────

  bootstrap_self_managed_addons = true
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional: Enable the cluster endpoint public access
  cluster_endpoint_public_access = true
  # map_users = [
  #   {
  #     userarn  = "arn:aws:iam::589736534170:user/Hamza_Khan"
  #     username = "hamza"
  #     groups   = ["system:masters"]
  #   }
  # ]

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions  = true
  cluster_enabled_log_types                 = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  enable_irsa = true

  # ─────────────────────────────────────────────────────────────────────
  #                     Encryption at rest
  # ─────────────────────────────────────────────────────────────────────
  # 1) Let the module create a CMK for you
  create_kms_key                = true                # ✅ Controls if CMK is created :contentReference[oaicite:0]{index=0}
  kms_key_enable_default_policy = true                # Include the AWS-managed default key policy
  kms_key_aliases               = ["eks-etcd"]  # Helpful for console lookup
  kms_key_description           = "my-cluster cluster encryption key"  
  
  # 2) Tell EKS to encrypt “secrets” using that CMK
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  # ─────────────────────────────────────────────────────────────────────
  #                     EKS Managed Node Group(s)
  # ─────────────────────────────────────────────────────────────────────
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
