**Задание 1**

![image](https://github.com/user-attachments/assets/7031ddcc-b1d3-4ad8-a102-b683e0217180)

**Задание 2**

for_each-vm.tf

```
resource "yandex_compute_instance" "platform2" {
  for_each = {
    "0" = "main"
    "1" = "replica"
  }
  name        = "${var.each_vm[each.key]["vm_name"]}${each.value}"
  platform_id = "${var.vm_platform}"
  resources {
    cores         = "${var.each_vm[each.key]["cpu"]}"
    memory        = "${var.each_vm[each.key]["ram"]}"
    core_fraction = "${var.each_vm[each.key]["core_fraction"]}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size   = "${var.each_vm[each.key]["disk_volume"]}"
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids  = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${local.key}"
  }
}
```

count-vm.tf

```
data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  depends_on = [yandex_compute_instance.platform2]

  count = 2

  name        = "${var.vm_def_name}${count.index+1}"
  platform_id = "${var.vm_platform}"
  resources {
    cores         = "${var.vm_web_resources.cores}"
    memory        = "${var.vm_web_resources.memory}"
    core_fraction = "${var.vm_web_resources.core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids  = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${local.key}"
  }
}
```

variables.tf

```
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
  }
  ]
}

```
