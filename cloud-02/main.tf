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

resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = var.network.priv.v4_cidr_blocks
  name           = var.network.priv.name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netolab.id
  # route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
    bucket_uri         = yandex_storage_object.picture.bucket
    object_s3_uri      = yandex_storage_object.picture.key
  }
}