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
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_web_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

 variable "vm_web_resources" {
   type        = map(number)
   default     = { cores = 2, memory = 1, core_fraction = 5 }
   description = "VM Resources"
 }

variable "disk_properties" {
  type = map(object({
    name = string
    type = string
    size = number
  }))
  default = {
    "data" = {
      name = "disk-"
      type = "network-hdd"
      size = 1
    }
  }
  
}

variable "vms_meta" {
  type = map(object({
    serial-port-enable = number
#    ssh-keys = string
  }))
  default = {
    "data" = {
      serial-port-enable = 1
#      ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
    }
  }
  
}

variable "vm_def_name" {
  type        = string
  default     = "web-"
  description = "Default VM Name"
}

variable "each_vm" {
  description = "each_virtual_machines"
  type        = list(object({
    vm_name = string
    cpu  = number
    ram  = number
    core_fraction = number
    disk_volume = number
  }))
  default     = [{
    vm_name = "db-"
    cpu = 2
    ram = 2
    core_fraction = 20
    disk_volume = 10
  },
  {
    vm_name = "db-"
    cpu = 2
    ram = 1
    core_fraction = 5
    disk_volume = 5
  },
  {
    vm_name = "storage"
    cpu = 2
    ram = 1
    core_fraction = 5
    disk_volume = 5
  }
  ]
}
