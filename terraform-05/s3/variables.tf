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

variable "service_acc_name" {
  type        = string
  default     = "serviceacc"
}

variable "service_acc_role" {
  type        = string
  default     = "storage.admin"
}

variable "bucket" {
  type = map(object({
    name = string
    max_size = number
    storage_class = string
    env = string
    grant_type = string
    permissions = list(string)
  }))
  default = {
    "data" = {
      name = "buckettimofeevan"
      max_size = 1073741824
      storage_class = "STANDARD"
      env = "dev"
      grant_type = "CanonicalUser"
      permissions = [ "READ", "WRITE" ]
    }
  }
}

variable "db" {
  type = map(object({
    name = string
    deletion_protection = bool
    storage_size_limit = number
    role = string
  }))
  default = {
    "data" = {
      name = "tfstatedb"
      deletion_protection = false
      storage_size_limit = 1
      role = "ydb.editor"
    }
  }
}