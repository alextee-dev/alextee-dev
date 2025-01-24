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

variable "env_name" {
  type    = string
  default = null
}

variable "subnets" {
  type = list(object({
    zone = string
    cidr = list(string)
  }))

}