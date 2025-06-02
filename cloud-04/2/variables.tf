###cloud vars
variable "cloud_id" {
  type        = string
  default     = "b1g6ufvpo7vkirq2qlm7"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g7scrj5f0n2u2d9n3l"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "service_account_id" {
  type        = string
  default     = "aje30c19em17t0i7uqfb"
}

### Network vars

variable "network" {
  type = map(object({
    v4_cidr_blocks = any
    name = string
    zone = string
  }))  
  default = {
    "pub-a" = {
      v4_cidr_blocks = ["192.168.10.0/24"]
      name = "public-a"
      zone = "ru-central1-a"
    },
    "pub-b" = {
      v4_cidr_blocks = ["192.168.20.0/24"]
      name = "public-b"
      zone = "ru-central1-b"
    },
    "pub-d" = {
      v4_cidr_blocks = ["192.168.30.0/24"]
      name = "public-d"
      zone = "ru-central1-d"
    },
    "priv-a" = {
      v4_cidr_blocks = ["192.168.40.0/24"]
      name = "private-a"
      zone = "ru-central1-a"
    },
    "priv-b" = {
      v4_cidr_blocks = ["192.168.50.0/24"]
      name = "private-b"
      zone = "ru-central1-b"
    }
  }
}

variable "net_name" {
  type        = string
  default     = "netogy-lab"
  description = "Network name"
}

variable "net_desc" {
  type        = string
  default     = "Netology Cloud lessons"
  description = "Network description"
}

### NAT vars

variable "nat_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "NAT Image ID"
}

variable "nat_vm_name" {
 type        = string
 default     = "nat"
 description = "NAT VM Name"
}


### VMs vars

variable "vm_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

variable "pub_vm_name" {
 type        = string
 default     = "pub-vm"
 description = "VM Name in Public network"
}

variable "priv_vm_name" {
 type        = string
 default     = "priv-vm"
 description = "VM Name in Private network"
}

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
    disk_size = number
    disk_type = string
    disk_name = string
    ip_address = string
  }))  
  default = {
    "nat" = {
      cores = 2
      memory = 2
      core_fraction = 20
      disk_size = 10
      disk_type = "network-hdd"
      disk_name = "boot-disk-nat"
      ip_address = "192.168.10.254"
    },
    "vm" = {
      cores = 2
      memory = 2
      core_fraction = 20
      disk_size = 10
      disk_type = "network-hdd"
      disk_name = "boot-disk-vm"
      ip_address = "192.168.10.254"
    }
  }
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/yc-ansible.pub"
}

variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2404-lts-oslogin"
  description = "OS Family"
}

### VM Group vars

variable "vm_group_resources" {
  type = map(object({
    name = string
    cores = number
    memory = number
    image_id = string
    disk_size = number
  }))  
  default = {
    "group1" = {
      name = "test-ig"
      cores = 2
      memory = 2
      image_id = "fd827b91d99psvq5fjit"
      disk_size = 10
    }
  }
}

### Bucket vars

variable "bucket" {
  type = map(object({
    name = string
    max_size = number
    default_storage_class = string
  }))  
  default = {
    "my" = {
      name = "atimofeev-27052025"
      max_size = 1073741824
      default_storage_class = "STANDARD"
    }
  }
}

### Load Balancer vars

variable "balancer" {
  type = map(object({
    name = string
    target_group_name = string
    listener_name = string
    router_name = string
    virtual_host_name = string
    route_name = string
    backend_group = string
    http_backend = string
  }))  
  default = {
    "nlb" = {
      name = "network-load-balancer-1"
      target_group_name = "target-group"
      listener_name = "http-listener"
      router_name = "http-router"
      virtual_host_name = "virtual-host"
      route_name = "route"
      backend_group = "backend-group"
      http_backend = "http-backend"
    },
    "alb" = {
      name = "application-load-balancer-1"
      target_group_name = "target-group"
      listener_name = "http-listener"
      router_name = "http-router"
      virtual_host_name = "virtual-host"
      route_name = "route"
      backend_group = "backend-group"
      http_backend = "http-backend"
    }
  }
}

### KMS vars

variable "kms" {
  type = map(object({
    name = string
    algorithm = string
    sse_algorithm = string
  }))  
  default = {
    "key" = {
      name = "test-symetric-key"
      algorithm = "AES_256"
      sse_algorithm = "aws:kms"
    }
  }
}


### MySQL vars

variable "mysql_resources" {
  type = map(object({
    name: string
    environment = string
    version = string
    deletion_protection = bool
    resource_preset_id = string
    disk_type_id  = string
    disk_size = number
    maintenance_type = string
    maintenance_day = string
    maintenance_hour = number
    backup_hour = number
    backup_min = number
  }))
  default = {
    "data" = {
      name: "mysql_cluster"
      environment = "PRESTABLE"
      version = "8.0"
      deletion_protection = false
      resource_preset_id = "b1.medium"
      disk_type_id  = "network-hdd"
      disk_size = 20
      maintenance_type = "WEEKLY"
      maintenance_day = "SAT"
      maintenance_hour = 12
      backup_hour = 23
      backup_min = 59
    }
  }
}

variable "mysql_db" {
  type = map(object({
    name = string
    user = string
  }))
  default = {
    "db" = {
      name = "netology_db"
      user = "neto_user"
    }
  }
}

### K8s vars

variable "sa-k8s" {
  type = map(object({
    name = string
    role_vpcadmin = string
    role_agent = string
    role_puller = string
    role_enc = string
    key_name = string
    key_algorithm = string
    key_rotation = string
  }))
  default = {
    "account" = {
      name = "sa-k8s"
      role_vpcadmin = "vpc.publicAdmin"
      role_agent = "k8s.clusters.agent"
      role_puller = "container-registry.images.puller"
      role_enc = "kms.keys.encrypterDecrypter"
      key_name = "kms-key"
      key_algorithm = "AES_256"
      key_rotation = "8760h"
    }
  }
}

variable "cluster-k8s" {
  type = map(object({
    name = string
    nodes_name = string
    instance_name = string
    platform = string
    network = string
    container = string
  }))
  default = {
    "data" = {
      name = "k8s-ha-cluster"
      nodes_name = "workers"
      instance_name = "test-{instance.short_id}"
      platform = "standard-v2"
      network = "standard"
      container = "containerd"
    }
  }
}