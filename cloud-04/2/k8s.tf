resource "yandex_kubernetes_cluster" "k8s-ha-cluster" {
  name = var.cluster-k8s.data.name
  network_id = yandex_vpc_network.netolab.id
  
  master {
    master_location {
      zone      = yandex_vpc_subnet.public-a.zone
      subnet_id = yandex_vpc_subnet.public-a.id
    }
    master_location {
      zone      = yandex_vpc_subnet.public-b.zone
      subnet_id = yandex_vpc_subnet.public-b.id
    }
    master_location {
      zone      = yandex_vpc_subnet.public-d.zone
      subnet_id = yandex_vpc_subnet.public-d.id
    }
    public_ip = true
    security_group_ids = [yandex_vpc_security_group.ha-k8s-sg.id]
  }
  service_account_id      = yandex_iam_service_account.sa-k8s.id
  node_service_account_id = yandex_iam_service_account.sa-k8s.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.key-sym.id
  }
}

resource "yandex_kubernetes_node_group" "k8s_workers" {
  cluster_id = yandex_kubernetes_cluster.k8s-ha-cluster.id
  name       = var.cluster-k8s.data.nodes_name

  instance_template {
    name       = var.cluster-k8s.data.instance_name
    platform_id = var.cluster-k8s.data.platform
    network_acceleration_type = var.cluster-k8s.data.network
    nat = true
    container_runtime {
      type = var.cluster-k8s.data.container
    }
  }

    scale_policy {
        auto_scale {
        min     = 3
        max     = 6
        initial = 3
        }
    }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public-a.zone
      subnet_id = yandex_vpc_subnet.public-a.id
    }
  }
}


resource "yandex_vpc_security_group" "ha-k8s-sg" {
  name        = "ha-k8s-sg"
  description = "Правила группы обеспечивают базовую работоспособность кластера Managed Service for Kubernetes. Примените ее к кластеру и группам узлов."
  network_id  = yandex_vpc_network.netolab.id
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера Managed Service for Kubernetes и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера Managed Service for Kubernetes и сервисов."
    v4_cidr_blocks    = concat(yandex_vpc_subnet.public-a.v4_cidr_blocks, yandex_vpc_subnet.public-b.v4_cidr_blocks, yandex_vpc_subnet.public-d.v4_cidr_blocks)
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ICMP"
    description       = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 30000
    to_port           = 32767
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 443
  }
  egress {
    protocol          = "ANY"
    description       = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
}


