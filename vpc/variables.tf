variable "vpc_name" {
  description = "vpc cluster name"
  type = string
  default = "my-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type = string
  default = "10.10.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "public_subnets" {
  description = "Public subnets"
  type = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnets"
  type = list(string)  
  default = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type = bool
  default = true
}

variable "single_nat_gateway" {
  description = "Single NAT Gateway"
  type = bool
  default = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type = bool
  default = true
}

variable "tags" {
  description = "Tags for the VPC"
  type = map(string)
  default = {"kubernetes.io/cluster/eks-cluster" = "shared"}
}

variable "public_subnet_tags" {
  description = "Tags for the public subnets"
  type = map(string)
  default = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

variable "private_subnet_tags" {
  description = "Tags for the private subnets"
  type = map(string)
  default = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
