variable "vm_db_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_db_name" {
 type        = string
 default     = "db"
 description = "db VM Name"
}

variable "vm_db_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

# variable "vm_db_resources" {
#   type        = map(number)
#   default     = { cores = 2, memory = 2, core_fraction = 20 }
#   description = "VM Resources"
# }

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "VM zone"
}