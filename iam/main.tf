module "irsa_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-eks-oidc-provider"
  version = "5.30.0"

  cluster_name = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
}
