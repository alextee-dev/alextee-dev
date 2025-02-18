variable "name" {
  type    = string
  default = null
}

variable "network_id" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "HA" {
  type        = bool
  default     = null
}

variable "host_count" {
  type        = number
  default     = 2
}

variable "mysql_resources" {
  type = map(object({
    environment = string
    version = string
    deletion_protection = bool
    resource_preset_id = string
    disk_type_id  = string
    disk_size = number
    zone  = string
    assign_public_ip  = bool
  }))
  default = {
    "data" = {
      environment = "PRESTABLE"
      version = "8.0"
      deletion_protection = false
      resource_preset_id = "c3-c2-m4"
      disk_type_id  = "network-hdd"
      disk_size = 20
      zone  = "ru-central1-a"
      assign_public_ip  = true
    }
  }
}
