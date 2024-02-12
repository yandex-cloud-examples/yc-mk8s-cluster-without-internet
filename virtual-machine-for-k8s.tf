# RU: https://cloud.yandex.ru/docs/managed-kafka/tutorials/deploy-kafka-ui
# EN: https://cloud.yandex.com/en/docs/managed-kafka/tutorials/deploy-kafka-ui
#
# Set the following settings:
locals {
  folder_id       = "" # Your cloud folder ID, same as for the Yandex Cloud provider.
  network_id      = "" # ID of the network created with the Yandex Managed Service for Kubernetes cluster.
  subnet_id       = "" # ID of the subnet created with the Yandex Managed Service for Kubernetes cluster and located in the ru-central1-b availability zone.
  vm_username     = "" # Set the username to connect to the VM via SSH.
  vm_ssh_key_path = "" # Set the path to the SSH public key for the VM. Example: "~/.ssh/key.pub".
}

resource "yandex_iam_service_account" "vm-sa" {
  name        = "vm-sa"
  description = "Service account for the VM"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster-api_cluster-admin" {
  # The service account is assigned the k8s.cluster-api.cluster-admin role
  folder_id = local.folder_id
  role      = "k8s.cluster-api.cluster-admin"
  member    = "serviceAccount:${yandex_iam_service_account.vm-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_admin" {
  # The service account is assigned the k8s.admin role
  folder_id = local.folder_id
  role      = "k8s.admin"
  member    = "serviceAccount:${yandex_iam_service_account.vm-sa.id}"
}

resource "yandex_vpc_security_group" "vm-security-group" {
  name        = "vm-security-group"
  description = "Security group for the VM"
  network_id  = local.network_id

  ingress {
    description    = "Allows connections to the VM via SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "my-vm" {
  name        = "my-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"

  resources {
    cores  = "2"
    memory = "2" # GB
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vljd295nqdaoogf3g" # Image of the Ubuntu 22.04 operating system.
    }
  }

  network_interface {
    subnet_id          = local.subnet_id
    nat                = true # Assigns a public address to the VM.
    security_group_ids = [yandex_vpc_security_group.vm-security-group.id]
  }

  metadata = {
    # Set a username and path for an SSH public key
    ssh-keys = "local.vm_username:${file(local.vm_ssh_key_path)}"
  }
}
