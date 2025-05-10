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

variable "zone1" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

###common vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/ycservice.pub"
}

variable "vm_marketing_name" {
  type        = string
  default     = "webs"
}

variable "vm_analytics_name" {
  type        = string
  default     = "web-stage"
}

variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vpc_prod" {
  description = "List of subnets with zones and CIDR blocks"
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  default = [
    {
      zone = "ru-central1-a"
      cidr = ["10.0.1.0/24"]
    },
    {
      zone = "ru-central1-b"
      cidr = ["10.0.2.0/24"]
    },
    {
      zone = "ru-central1-d"
      cidr = ["10.0.3.0/24"]
    }
  ]
}

variable "vpc_dev" {
  description = "List of subnets with zones and CIDR blocks"
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  default = [
    {
      zone = "ru-central1-a"
      cidr = ["10.0.1.0/24"]
    }
  ]
}

variable "prod_name" {
  type        = string
  default     = "prod"
}

variable "dev_name" {
  type        = string
  default     = "dev"
}

variable "cluster1_name" {
  type = string
  default = "managed"
}

variable "cluster2_name" {
  type = string
  default = "example"
}

variable "db_managed_name" {
  type = string
  default = "QWERTYdb"
}

variable "db_managed_user" {
  type = string
  default = "testuser"
}

variable "db_example_name" {
  type = string
  default = "test"
}

variable "db_example_user" {
  type = string
  default = "app"
}
