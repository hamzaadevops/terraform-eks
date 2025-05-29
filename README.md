# Terraform EKS Cluster Setup

This repository contains Terraform code to provision an Amazon EKS (Elastic Kubernetes Service) cluster with IAM roles, user access management, and core Kubernetes addons using Terraform AWS modules.

---

## 🧱 Features

- **Provision EKS cluster** using [terraform-aws-modules/eks](https://github.com/terraform-aws-modules/terraform-aws-eks)
- **IAM role for Kubernetes access**, with group-based policy management
- **Amazon EKS managed node groups** with customizable instance types
- **Encryption at rest** using AWS KMS for Kubernetes secrets
- **Amazon VPC CNI ConfigMap** management via Kubernetes provider
- **Helm provider** integration for installing addons like `metrics-server`

---

## 📁 Project Structure
```bash
.
├── main.tf # Main Terraform file with all resources
├── variables.tf # Input variables definition
├── outputs.tf # Outputs after Terraform apply
└── README.md # You're reading it!
```
## 🔧 Prerequisites

- Terraform v1.5+
- AWS CLI configured with sufficient permissions
- AWS account and IAM credentials
- kubectl installed
- Helm installed

## 🚀 Usage

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/terraform-eks-setup.git
cd terraform-eks-setup
```

### 2. Configure Required Variables
Define required variables in terraform.tfvars or via environment variables:

```hcl
    cluster_name    = "my-eks-cluster"
    cluster_version = "1.30"
    vpc_id          = "vpc-xxxxxxxx"
    subnet_ids      = ["subnet-aaaaaaa", "subnet-bbbbbbb"]
    ami_type        = "AL2_x86_64"
    instance_types  = ["m5.large"]
    min_size        = 1
    desired_size    = 2
    max_size        = 3
```

### 3. Initialize Terraform
```bash
    terraform init
```

### 4. Apply Terraform
```bash
    terraform plan
    terraform apply
```

## 👥 IAM Setup and Access Control

- Creates an IAM role eks_admin_role for EKS access.
- Only members of the Administrators IAM group can assume this role.
- IAM user alice is created and added to the group as an example.

## 🔐 Security Features

- Kubernetes secrets are encrypted at rest using a customer-managed KMS key.
- Least-privilege principle applied for IAM policies (via sts:AssumeRole).

## 📦 Installed Addons

These are provisioned by the EKS module:
- coredns
- kube-proxy
- vpc-cni
- eks-pod-identity-agent

## 📊 Helm-based Addons

The metrics-server is deployed via the Helm provider using:
```hcl
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.11.0"
}
```


# terraform import 
in case we get this error
```bash
module.eks.kubernetes_config_map.amazon_vpc_cni: Creating...
╷
│ Error: Post "https://20D4F2EC51150695D7F2BE2B3CBD8BEF.yl4.ap-south-1.eks.amazonaws.com/api/v1/namespaces/kube-system/configmaps": tls: failed to verify certificate: x509: certificate signed by unknown authority
│ 
│   with module.eks.kubernetes_config_map.amazon_vpc_cni,
│   on eks/config-map.tf line 21, in resource "kubernetes_config_map" "amazon_vpc_cni":
│   21: resource "kubernetes_config_map" "amazon_vpc_cni" {
│ 
╵
```

RUn the below command to import the config map
```bash
terraform import module.eks.kubernetes_config_map.amazon_vpc_cni kube-system/amazon-vpc-cni
terraform import module.eks.kubernetes_config_map.aws_auth kube-system/aws-auth
```
