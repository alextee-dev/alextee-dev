variable "name" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}

variable "v4_cidr_blocks" {
  type    = list(string)
  default = null
}
