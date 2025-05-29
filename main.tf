module "vpc" {
  source = "./vpc"
}

module "eks" {
  source             = "./eks"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  iam_role_arn      = module.iam.iam_role_arn
  eks_admin_role_arn = module.iam.eks_admin_role_arn
}

module "iam" {
  source = "./iam"
}
