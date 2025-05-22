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
```