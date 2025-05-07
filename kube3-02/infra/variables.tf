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

variable "subnet_id" {
  type        = string
  default     = "e9b32bd85lngtj3c4msa"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_web_os_family1" {
  type        = string
  default     = "ubuntu-2004-lts-oslogin"
  description = "OS Family"
}

variable "vm_web_os_family2" {
  type        = string
  default     = "ubuntu-2404-lts-oslogin"
  description = "OS Family"
}

variable "vm_name" {
 type        = string
 default     = "kuber-"
 description = "VM Name"
}

variable "vm_name_2" {
 type        = string
 default     = "gitlab-agent"
 description = "Agent VM Name"
}

variable "vm_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))  
  default = {
    "ans1" = {
      cores = 2
      memory = 4
      core_fraction = 20
    },
    "db" = {
      cores = 2
      memory = 2
      core_fraction = 20 
    }
  }
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/yc-ansible.pub"
}

variable "vms_ssh_private_key" {
  type        = string
  default     = "~/.ssh/yc-ansible"
}