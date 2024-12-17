Задание 1
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
