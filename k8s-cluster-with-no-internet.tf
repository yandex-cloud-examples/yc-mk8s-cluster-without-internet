# Infrastructure for the Yandex Cloud Managed Service for Kubernetes cluster isolated from the internet
#
# RU: https://cloud.yandex.ru/ru/docs/managed-kubernetes/tutorials/k8s-cluster-with-no-internet
# EN: https://cloud.yandex.com/en/docs/managed-kubernetes/tutorials/k8s-cluster-with-no-internet
#
# Creates a net, subnets, a routing table, and a default security group
module "net" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-vpc.git"
  network_description = "without internet"
  network_name        = "module-net"
  create_nat_gw       = false # The NAT gatewey creation is turned off.
  private_subnets = [
    {
      "v4_cidr_blocks" : ["10.121.0.0/16"],
      "zone" : "ru-central1-a",
    },
    {
      "v4_cidr_blocks" : ["10.131.0.0/16"],
      "zone" : "ru-central1-b"
    },
    {
      "v4_cidr_blocks" : ["10.141.0.0/16"],
      "zone" : "ru-central1-c"
    },
  ]
}

# Creates security groups for the Managed Service for Kubernetes, service accounts, symmetric key in Yandex Key Management Service, the Managed Service for Kubernetes cluster, and a node group
module "kube" {
  source                      = "git::https://github.com/terraform-yc-modules/terraform-yc-kubernetes.git"
  cluster_name                = "kube-regional-cluster"
  description                 = "Kubernetes cluster without internet access"
  cluster_version             = "1.25"
  network_id                  = module.net.vpc_id
  public_access               = false # No public address is assigned to the cluster.
  enable_cilium_policy        = true  # Tunnel mode is turned on.
  allow_public_load_balancers = false # Services of the loadbalancer type with a public address are not allowed.
  master_locations = [for k, v in module.net.private_subnets : v]
  node_groups = {
    "yc-k8s-ng-01" = {
      version     = "1.25"
      description = "Kubernetes nodes group without internet access"
      nat         = false  # No public address is assigned to the node group.
      fixed_scale = {
        size = 3
      }
    }
  }
}
