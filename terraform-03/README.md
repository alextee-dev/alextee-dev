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
    ssh-keys           = "${local.ubukey}"
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
    ssh-keys           = "${local.ubukey}"
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

locals.tf

```
locals {

key = file("~/.ssh/ycservice.pub")
ubukey = "ubuntu:${local.key}"
    }
```

**Задание 3**

disk_vm.tf

```
resource "yandex_compute_disk" "disks" {
    count = 3
  name     = "${var.disk_properties.data.name}${count.index}"
  type     = "${var.disk_properties.data.type}"
  zone     = "${var.default_zone}"
  size     = "${var.disk_properties.data.size}"
}

resource "yandex_compute_instance" "platform3" {
  name        = "${var.each_vm[2]["vm_name"]}"
  platform_id = "${var.vm_platform}"
  resources {
    cores         = "${var.each_vm[2]["cpu"]}"
    memory        = "${var.each_vm[2]["ram"]}"
    core_fraction = "${var.each_vm[2]["core_fraction"]}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size   = "${var.each_vm[2]["disk_volume"]}"
    } 
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks
    content {
      disk_id     = secondary_disk.value["id"]
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
    ssh-keys           = "${local.ubukey}"
  }

}
```

![image](https://github.com/user-attachments/assets/acce3274-51ae-41b5-b3d8-923ed4df62fa)

**Задание 4**

![image](https://github.com/user-attachments/assets/cbc37aa8-19d7-4ee4-a53d-c8ac0e3b52f0)

**Задание 5**

![image](https://github.com/user-attachments/assets/4a95fc67-4161-48f5-9e48-47ed77d94935)

```
output "count" {

  value = [
    { name = yandex_compute_instance.platform.*.name
      id = yandex_compute_instance.platform.*.id
      fqdn = yandex_compute_instance.platform.*.fqdn}
  ]
}

output "for_each" {

  value = [
   { name = values(yandex_compute_instance.platform2).*.name
      id = values(yandex_compute_instance.platform2).*.id
      fqdn = values(yandex_compute_instance.platform2).*.fqdn}
  ]
}

output "single_vm" {

  value = [
    { name = yandex_compute_instance.platform3.name
      id = yandex_compute_instance.platform3.id
      fqdn = yandex_compute_instance.platform3.fqdn}
  ]
}

```

**Задание 6**

ansible.tf

```
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { webservers = yandex_compute_instance.platform, databases = yandex_compute_instance.platform2, storage = yandex_compute_instance.platform3 })

  filename = "${abspath(path.module)}/hosts.ini"
}

resource "null_resource" "web_hosts_provision" {
  depends_on = [yandex_compute_instance.platform, yandex_compute_instance.platform2, yandex_compute_instance.platform3]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command    = "> ~/.ssh/known_hosts &&eval $(ssh-agent) && cat ~/.ssh/ycservice | ssh-add -"
    on_failure = continue
  }

  provisioner "local-exec" {
     command = "sleep 120"
   }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/hosts.ini ${abspath(path.module)}/test.yml"
    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
  triggers = {
    always_run      = "${timestamp()}"
    always_run_uuid = "${uuid()}"

  }

}
```

hosts.tftpl

```
[webservers]

%{~ for i in webservers ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"] != "" ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]}   fqdn=${i["fqdn"]}
%{~ endfor ~}


[databases]

%{~ for i in databases ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"] != "" ? i["network_interface"][0]["nat_ip_address"] : i["network_interface"][0]["ip_address"]}   fqdn=${i["fqdn"]}}
%{~ endfor ~}


[storage]

${storage["name"]}   ansible_host=ansible_host=${storage["network_interface"][0]["nat_ip_address"] != "" ? storage["network_interface"][0]["nat_ip_address"] : storage["network_interface"][0]["ip_address"]}   fqdn=${storage["fqdn"]}}

```
**Задание 7**

```
{
  network_id  = local.vpc.network_id
  subnet_ids  = concat(slice(local.vpc.subnet_ids, 0, 2), slice(local.vpc.subnet_ids, 3, 4))
  subnet_zones = concat(slice(local.vpc.subnet_zones, 0, 2), slice(local.vpc.subnet_zones, 3, 4))
}
```

**Задание 8**
1. Нехватает закрывающей фигурной скобки после ["nat_ip_address"]
2. Лишний пробел в "platform_id "

**Задание 9**
1.  [ for i in range("1", "100", 1): "rc${i}"
2.  [ for i in range("1", "100", 1): "rc${i}" if !contains([0, 7, 8, 9], i % 10) || i == 19 ]
