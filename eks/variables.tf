variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
    default = "my-cluster"
}

variable "cluster_version"{
    description = "which k8s version to use"
    type        = string
    default     = "1.29"
}
variable "ami_type" {
    description = "The AMI type to use for the EKS managed node group"
    type        = string
    default     = "AL2023_x86_64_STANDARD"
}

variable "instance_types" {
    description = "The instance types to use for the EKS managed node group"
    type        = list(string)
    default     = ["t3.medium"]
}

variable "min_size" {
    description = "The minimum size of the EKS managed node group"
    type        = number
    default     = 1
}

variable "desired_size" {
    description = "The desired size of the EKS managed node group"
    type        = number
    default     = 2
}

variable "max_size" {
    description = "The maximum size of the EKS managed node group"
    type        = number
    default     = 3
}

variable "vpc_id" {
    description = "The VPC ID to use for the EKS cluster"
    type        = string
}

variable "subnet_ids" {
    description = "The subnet IDs to use for the EKS cluster"
    type        = list(string)
}

variable "eks_admin_role_arn" {
  type        = string
  description = "IAM role ARN used by EKS Administrators"
}

variable "iam_role_arn" {
  type        = string
  description = "IAM role ARN used by EKS worker nodes"
}
