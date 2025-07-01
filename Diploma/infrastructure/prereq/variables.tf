### Cloud
variable "cloud_id" {
  type        = string
  default     = "b1g6ufvpo7vkirq2qlm7"
}

variable "folder_id" {
  type        = string
  default     = "b1g7scrj5f0n2u2d9n3l"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

### Service account

variable "sa" {
  type = map(object({
    name = string
    role_vpcadmin = string
    role_storageadmin = string
    role_computeadmin = string
    key_algorithm = string
    key_file_path = string
    key_file_permission = string
    static_key_file_path = string
  }))
  default = {
    "account" = {
      name = "terraform-sa"
      role_vpcadmin = "vpc.admin"
      role_storageadmin = "storage.admin"
      role_computeadmin = "compute.admin"
      key_algorithm = "RSA_4096"
      key_file_path = "/root/.authorized_key_terraform.json"
      key_file_permission = "0600"
      static_key_file_path = "/root/.terraform_static_key"
    }
  }
}

### Bucket

variable "bucket" {
  type = map(object({
    name = string
    max_size = number
    default_storage_class = string
  }))  
  default = {
    "data" = {
      name = "atimofeev-bucket"
      max_size = 1073741824
      default_storage_class = "STANDARD"
    }
  }
}

### Container Registry

variable "registry_name" {
  type        = string
  default     = "docker-registry"
}

variable "registry_role" {
  type        = string
  default     = "container-registry.images.puller"
}

variable "registry_member" {
  type        = string
  default     = "system:allUsers"
}

### VPC

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

### VMs

variable "vm_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

variable "vms_resources" {
  type = map(object({
    name = string
    cores = number
    memory = number
    core_fraction = number
    disk_size = number
    disk_type = string
  }))  
  default = {
    "cicd" = {
      name = "cicd"
      cores = 4
      memory = 4
      core_fraction = 50
      disk_size = 20
      disk_type = "network-hdd"
    },
    "cicd-agent" = {
      name = "cicd-agent"
      cores = 2
      memory = 2
      core_fraction = 20
      disk_size = 10
      disk_type = "network-hdd"
    }
    
  }
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/yc-ansible.pub"
}

variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2204-lts-oslogin"
  description = "OS Family"
}

variable "inventory-cicd_path" {
  type        = string
  default     = "/home/atimofeev/Diploma/ansible/teamcity/inventory.ini"
}