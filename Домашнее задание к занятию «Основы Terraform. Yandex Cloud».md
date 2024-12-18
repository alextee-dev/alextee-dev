**Задание 1**
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
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
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

```
![4](https://github.com/user-attachments/assets/a84b4cdd-ed90-4893-8cca-ddb5f6eccfb7)

![4 1](https://github.com/user-attachments/assets/2c9657d9-ddc7-4163-85fe-9ef74276d57d)

    1.4 platform_id = "standart-v4" - в соотвествии со статьей https://yandex.cloud/ru/docs/compute/concepts/vm-platforms нет платформы v4, также допущена ошибка в слове standard
	      cores         = 1 - для этой платформы нельзя назначить менее 2 CPU
    1.6 preemptible = true и core_fraction=5 заметно снизят стоимость вм в облаке

**Задание 2**

Variables.tf
```
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
  default     = ["10.1.30.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "terraform-lab"
  description = "VPC network & subnet name"
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM Name"
}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

variable "vm_web_resources" {
  type        = map(number)
  default     = { cores = 2, memory = 1, core_fraction = 5 }
  description = "VM Resources"
}
```

main.tf
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${var.vm_web_name}"
  platform_id = "${var.vm_web_platform}"
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
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

```
![image](https://github.com/user-attachments/assets/bee691b5-d302-4830-bd63-68a9eec8faf1)

**Задание 3**

main.tf

```
resource "yandex_vpc_network" "develop-a" {
  name = var.vpc_name1
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name1
  zone           = var.default_zone-a
  network_id     = yandex_vpc_network.develop-a.id
  v4_cidr_blocks = var.default_cidr-a
}

resource "yandex_vpc_network" "develop-b" {
  name = var.vpc_name2
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name2
  zone           = var.default_zone-b
  network_id     = yandex_vpc_network.develop-b.id
  v4_cidr_blocks = var.default_cidr-b
}


data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${var.vm_web_name}"
  platform_id = "${var.vm_web_platform}"
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
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "platform2" {
  name        = "${var.vm_db_name}"
  platform_id = "${var.vm_db_platform}"
  zone        = "${var.vm_db_zone}"
  resources {
    cores         = "${var.vm_db_resources.cores}"
    memory        = "${var.vm_db_resources.memory}"
    core_fraction = "${var.vm_db_resources.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

variables.tf

```
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

variable "default_zone-a" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr-a" {
  type        = list(string)
  default     = ["10.1.30.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_zone-b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr-b" {
  type        = list(string)
  default     = ["10.1.40.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name1" {
  type        = string
  default     = "terraform-lab1"
  description = "VPC network & subnet name"
}

variable "vpc_name2" {
  type        = string
  default     = "terraform-lab2"
  description = "VPC network & subnet name"
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM Name"
}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

variable "vm_web_resources" {
  type        = map(number)
  default     = { cores = 2, memory = 1, core_fraction = 5 }
  description = "VM Resources"
}

```
vms_platform.tf

```
variable "vm_db_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM Name"
}

variable "vm_db_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

variable "vm_db_resources" {
  type        = map(number)
  default     = { cores = 2, memory = 2, core_fraction = 20 }
  description = "VM Resources"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "VM zone"
}
```
![image](https://github.com/user-attachments/assets/1bc623a4-4c6e-423c-9035-ee7724ef1bbd)

**Задание 4**

![image](https://github.com/user-attachments/assets/6c62b49c-7989-4b93-a79f-af664358f9ce)

**Задание 5**

locals.tf

```
locals {

web_name = "${var.vm_def_name}${var.vm_web_name}"
db_name = "${var.vm_def_name}${var.vm_db_name}"
    }
```

main.tf

```
resource "yandex_vpc_network" "develop-a" {
  name = var.vpc_name1
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name1
  zone           = var.default_zone-a
  network_id     = yandex_vpc_network.develop-a.id
  v4_cidr_blocks = var.default_cidr-a
}

resource "yandex_vpc_network" "develop-b" {
  name = var.vpc_name2
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name2
  zone           = var.default_zone-b
  network_id     = yandex_vpc_network.develop-b.id
  v4_cidr_blocks = var.default_cidr-b
}


data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${local.web_name}"
  platform_id = "${var.vm_web_platform}"
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
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "platform2" {
  name        = "${local.db_name}"
  platform_id = "${var.vm_db_platform}"
  zone        = "${var.vm_db_zone}"
  resources {
    cores         = "${var.vm_db_resources.cores}"
    memory        = "${var.vm_db_resources.memory}"
    core_fraction = "${var.vm_db_resources.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

**Задание 6**

main.tf

```
resource "yandex_vpc_network" "develop-a" {
  name = var.vpc_name1
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name1
  zone           = var.default_zone-a
  network_id     = yandex_vpc_network.develop-a.id
  v4_cidr_blocks = var.default_cidr-a
}

resource "yandex_vpc_network" "develop-b" {
  name = var.vpc_name2
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name2
  zone           = var.default_zone-b
  network_id     = yandex_vpc_network.develop-b.id
  v4_cidr_blocks = var.default_cidr-b
}


data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${local.web_name}"
  platform_id = "${var.vm_web_platform}"
  resources {
    cores         = "${var.vms_resources.web.cores}"
    memory        = "${var.vms_resources.web.memory}"
    core_fraction = "${var.vms_resources.web.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${var.vms_meta.data.ssh-keys}"
  }

}

resource "yandex_compute_instance" "platform2" {
  name        = "${local.db_name}"
  platform_id = "${var.vm_db_platform}"
  zone        = "${var.vm_db_zone}"
  resources {
    cores         = "${var.vms_resources.db.cores}"
    memory        = "${var.vms_resources.db.memory}"
    core_fraction = "${var.vms_resources.db.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${var.vms_meta.data.ssh-keys}"
  }

}
```

variables.tf

```
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

variable "default_zone-a" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr-a" {
  type        = list(string)
  default     = ["10.1.30.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_zone-b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr-b" {
  type        = list(string)
  default     = ["10.1.40.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name1" {
  type        = string
  default     = "terraform-lab1"
  description = "VPC network & subnet name"
}

variable "vpc_name2" {
  type        = string
  default     = "terraform-lab2"
  description = "VPC network & subnet name"
}

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
#   description = "ssh-keygen -t ed25519"
# }

variable "vm_web_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_web_name" {
 type        = string
 default     = "web"
 description = "web VM Name"
}

variable "vm_def_name" {
  type        = string
  default     = "netology-develop-platform-"
  description = "Default VM Name"
}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v2"
  description = "VM Platform Id"
}

# variable "vm_web_resources" {
#   type        = map(number)
#   default     = { cores = 2, memory = 1, core_fraction = 5 }
#   description = "VM Resources"
# }

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))  
  default = {
    "web" = {
      cores = 2
      memory = 1
      core_fraction = 5
    },
    "db" = {
      cores = 2
      memory = 2
      core_fraction = 20 
    }
  }
}

variable "vms_meta" {
  type = map(object({
    serial-port-enable = number
    ssh-keys = string
  }))
  default = {
    "data" = {
      serial-port-enable = 1
      ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj9cW+g+/Nz7G8IgpTcUcupNyS7frO5j9e+7VSAkLp9"
    }
  }
  
}
```
vms_platform.tf

```
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
```

**Задание 7**

![image](https://github.com/user-attachments/assets/d6186267-ab22-42bc-b4e5-5d94f4566c03)

**Задание 8**

```
variable "test" {
  type = map(object({
    dev1 = tuple([ string,string ])
    dev2 = tuple([ string,string ])
    prod1 = tuple([ string,string ])
  }))
  default = {
    "env" = {
      "dev1" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117", "10.0.1.7"]
      "dev2" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88", "10.0.2.29"]
      "prod1" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101", "10.0.1.30"]
      }
    }
  }
```
var.test.env.dev1.0

![image](https://github.com/user-attachments/assets/66f3f8e2-fe2d-4555-bd56-34abee0281d7)

**Задание 9**

main.tf

```
resource "yandex_vpc_network" "develop-a" {
  name = var.vpc_name1
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name1
  zone           = var.default_zone-a
  network_id     = yandex_vpc_network.develop-a.id
  v4_cidr_blocks = var.default_cidr-a
  route_table_id = yandex_vpc_route_table.rt1.id
}

resource "yandex_vpc_network" "develop-b" {
  name = var.vpc_name2
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name2
  zone           = var.default_zone-b
  network_id     = yandex_vpc_network.develop-b.id
  v4_cidr_blocks = var.default_cidr-b
  route_table_id = yandex_vpc_route_table.rt2.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt1" {
  name       = "test-route-table1"
  network_id = yandex_vpc_network.develop-a.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_vpc_route_table" "rt2" {
  name       = "test-route-table2"
  network_id = yandex_vpc_network.develop-b.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${local.web_name}"
  platform_id = "${var.vm_web_platform}"
  resources {
    cores         = "${var.vms_resources.web.cores}"
    memory        = "${var.vms_resources.web.memory}"
    core_fraction = "${var.vms_resources.web.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = false
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${var.vms_meta.data.ssh-keys}"
  }

}

resource "yandex_compute_instance" "platform2" {
  name        = "${local.db_name}"
  platform_id = "${var.vm_db_platform}"
  zone        = "${var.vm_db_zone}"
  resources {
    cores         = "${var.vms_resources.db.cores}"
    memory        = "${var.vms_resources.db.memory}"
    core_fraction = "${var.vms_resources.db.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = false
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${var.vms_meta.data.ssh-keys}"
  }

}
```
![image](https://github.com/user-attachments/assets/42062b1f-ec07-4cf8-b2dc-184f617b7574)

![image](https://github.com/user-attachments/assets/31d7e781-8df0-4a90-98f6-ff3404feb8e8)


