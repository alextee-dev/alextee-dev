### Create vpc and vpc subnet
resource "yandex_vpc_network" "netolab" {
  name        = var.net_name
  description = var.net_desc
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = var.network.pub.v4_cidr_blocks
  name           = var.network.pub.name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netolab.id
}

resource "yandex_vpc_subnet" "private-b" {
  v4_cidr_blocks = var.network.priv-b.v4_cidr_blocks
  name           = var.network.priv-b.name
  zone           = var.network.priv-b.zone
  network_id     = yandex_vpc_network.netolab.id
}

resource "yandex_vpc_subnet" "private-a" {
  v4_cidr_blocks = var.network.priv-a.v4_cidr_blocks
  name           = var.network.priv-a.name
  zone           = var.network.priv-a.zone
  network_id     = yandex_vpc_network.netolab.id
}