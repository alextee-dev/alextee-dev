### Create vpc and vpc subnet
resource "yandex_vpc_network" "netolab" {
  name        = var.net_name
  description = var.net_desc
}

resource "yandex_vpc_subnet" "public-a" {
  v4_cidr_blocks = var.network.pub-a.v4_cidr_blocks
  name           = var.network.pub-a.name
  zone           = var.network.pub-a.zone
  network_id     = yandex_vpc_network.netolab.id
}

resource "yandex_vpc_subnet" "public-b" {
  v4_cidr_blocks = var.network.pub-b.v4_cidr_blocks
  name           = var.network.pub-b.name
  zone           = var.network.pub-b.zone
  network_id     = yandex_vpc_network.netolab.id
}

resource "yandex_vpc_subnet" "public-d" {
  v4_cidr_blocks = var.network.pub-d.v4_cidr_blocks
  name           = var.network.pub-d.name
  zone           = var.network.pub-d.zone
  network_id     = yandex_vpc_network.netolab.id
}