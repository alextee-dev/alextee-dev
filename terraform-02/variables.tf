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

variable "default_zone-a" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr-a" {
  type        = list(string)
  default     = ["10.1.30.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_zone-b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr-b" {
  type        = list(string)
  default     = ["10.1.40.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name1" {
  type        = string
  default     = "terraform-lab1"
  description = "VPC network & subnet name"
}

variable "vpc_name2" {
  type        = string
  default     = "terraform-lab2"
  description = "VPC network & subnet name"
}

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
#   description = "ssh-keygen -t ed25519"
# }

variable "vm_web_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_web_name" {
 type        = string
 default     = "web"
 description = "web VM Name"
}

variable "vm_def_name" {
  type        = string
  default     = "netology-develop-platform-"
  description = "Default VM Name"
}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

# variable "vm_web_resources" {
#   type        = map(number)
#   default     = { cores = 2, memory = 1, core_fraction = 5 }
#   description = "VM Resources"
# }

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))  
  default = {
    "web" = {
      cores = 2
      memory = 1
      core_fraction = 5
    },
    "db" = {
      cores = 2
      memory = 2
      core_fraction = 20 
    }
  }
}

variable "vms_meta" {
  type = map(object({
    serial-port-enable = number
    ssh-keys = string
  }))
  default = {
    "data" = {
      serial-port-enable = 1
      ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
    }
  }
  
}

# задание 8

# variable "test" {
#   type = map(object({
#     dev1 = tuple([ string,string ])
#     dev2 = tuple([ string,string ])
#     prod1 = tuple([ string,string ])
#   }))
#   default = {
#     "env" = {
#       "dev1" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117", "10.0.1.7"]
#       "dev2" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88", "10.0.2.29"]
#       "prod1" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101", "10.0.1.30"]
#       }
#     }
#   }