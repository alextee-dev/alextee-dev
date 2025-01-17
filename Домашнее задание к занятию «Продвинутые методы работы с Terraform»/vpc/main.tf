terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_sub" {
  for_each = { for subnet in var.subnets : subnet.zone => subnet }
  name           = "${var.name}_${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = each.value.cidr
}