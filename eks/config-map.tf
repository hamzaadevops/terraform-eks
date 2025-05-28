# ─────────────────────────────────────────────────────────────────────
#                Kubernetes Provider Configuration
# ─────────────────────────────────────────────────────────────────────

provider "kubernetes" {
  host = module.eks.cluster_endpoint

  cluster_ca_certificate = base64decode(
    module.eks.cluster_certificate_authority_data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = [
      "eks", "get-token",
      "--cluster-name", module.eks.cluster_name,
    ]
  }
}

# ─────────────────────────────────────────────────────────────────────
#                Managing ConfigMap of VPC_CNI
# ─────────────────────────────────────────────────────────────────────

# Fetch your current AWS account ID
data "aws_caller_identity" "current" {}

resource "kubernetes_config_map" "amazon_vpc_cni" {
  metadata {
    name      = "amazon-vpc-cni"
    namespace = "kube-system"
    labels = {
    "app.kubernetes.io/instance" = "aws-vpc-cni"
    "app.kubernetes.io/managed-by" = "Helm"
    "app.kubernetes.io/name" = "aws-node"
    "k8s-app" = "aws-node"
    "helm.sh/chart" = "aws-vpc-cni-1.19.0"
    "app.kubernetes.io/version" = "v1.19.0"
  }
  }

  data = {
    # The number of ENIs to keep pre-allocated. Setting to "0" means no extra ENIs are kept warm.
    "warm-eni-target" = "0"

    # The number of prefix blocks (/28 or /29 CIDR) to keep warm. Only applicable when ENABLE_PREFIX_DELEGATION is enabled.
    "warm-prefix-target" = "1"

    # The minimum number of IP addresses to allocate for pod networking. Ensures a minimum number of IPs are always available.
    "minimum-ip-target" = "2"

    # The number of IP addresses to keep warm and ready to allocate to pods.
    # Helps reduce pod startup latency by maintaining a pool of ready-to-use IPs.
    "warm-ip-target" = "1"

    # Enable or disable Prefix Delegation. When set to "true", the CNI plugin will allocate CIDR prefixes instead of individual IPs.
    # This optimizes IP address usage and reduces the number of ENIs required.
    "enable-prefix-delegation" = "false"

    # Enable or disable the usage of dedicated ENIs for each pod.
    # When set to "true", each pod gets its own ENI with a single IP. This is useful for higher network throughput.
    "enable-pod-eni" = "false"

    "branch-eni-cooldown" = "60"
    "enable-network-policy-controller" = "false"
    "enable-windows-ipam" = "false"
    "enable-windows-prefix-delegation" = "false"
  }

  depends_on = [module.eks]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks_access_to_iam"
        username = "eks-admin"
        groups   = ["system:masters"]
      }
    ])
  }
  depends_on = [module.eks]
}
