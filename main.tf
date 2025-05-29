module "vpc" {
  source = "./vpc"
}

module "eks" {
  source             = "./eks"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  iam_role_arn       = module.iam.iam_role_arn
  eks_admin_role_arn = module.iam.eks_admin_role_arn
  cluster_name       = var.cluster_name
  alb_irsa_role_arn  = module.iam.alb_irsa_role_arn
  region             = var.region
}

module "iam" {
  source = "./iam"
  cluster_name       = var.cluster_name
  oidc_provider_arn  = module.eks.oidc_provider_arn
  cluster_oidc_issuer_url  = module.eks.cluster_oidc_issuer_url
}
