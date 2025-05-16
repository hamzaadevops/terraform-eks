# resource "aws_kms_key" "eks_etcd" {
#   description             = "EKS etcd envelope encryption"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
# }

module "vpc" {
  source = "./vpc"
}

module "eks" {
  source = "./eks"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}
