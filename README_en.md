# Creating and configuring a Managed Service for Kubernetes® cluster with no internet access

You can create and configure a Managed Service for Kubernetes® cluster with no internet connectivity. For this, you will need the following configuration:

* The Managed Service for Kubernetes cluster and node group have no public address. You can only connect to such a cluster with a Yandex Cloud virtual machine.
* The cluster and node group are hosted by subnets with no internet access.
* Service accounts have no permissions to use resources with internet access, such as [Yandex Network Load Balancer](https://yandex.cloud/docs/network-load-balancer/).
* Cluster security groups restrict incoming and outgoing traffic.

For details, see [this step-by-step guide](https://yandex.cloud/docs/managed-kubernetes/tutorials/k8s-cluster-with-no-internet) in the Yandex Cloud documentation.
