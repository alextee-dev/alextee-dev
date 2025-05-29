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
  default     = "ru-central1-d"
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
  }))  
  default = {
    "pub" = {
      v4_cidr_blocks = ["192.168.10.0/24"]
      name = "public"
    },
    "priv" = {
      v4_cidr_blocks = ["192.168.20.0/24"]
      name = "private"
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