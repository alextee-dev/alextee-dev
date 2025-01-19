terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = var.name
  environment         = var.mysql_resources.data.environment
  network_id          = var.network_id
  version             = var.mysql_resources.data.version
  deletion_protection = var.mysql_resources.data.deletion_protection

  resources {
    resource_preset_id = var.mysql_resources.data.resource_preset_id
    disk_type_id       = var.mysql_resources.data.disk_type_id
    disk_size          = var.mysql_resources.data.disk_size
  }

  dynamic "host" {
    for_each = var.HA ? [for i in range(var.host_count) : i] : [1]
    content {
      subnet_id       = var.subnet_id
      zone            = var.mysql_resources.data.zone
      assign_public_ip = var.mysql_resources.data.assign_public_ip
    }
  }
}