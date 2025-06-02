
# Create a new MDB High Availability MySQL Cluster.

resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name        = var.mysql_resources.data.name
  environment = var.mysql_resources.data.environment
  network_id  = yandex_vpc_network.netolab.id
  version     = var.mysql_resources.data.version
  deletion_protection = var.mysql_resources.data.deletion_protection

  resources {
    resource_preset_id = var.mysql_resources.data.resource_preset_id
    disk_type_id       = var.mysql_resources.data.disk_type_id
    disk_size          = var.mysql_resources.data.disk_size
  }

  maintenance_window {
    type = var.mysql_resources.data.maintenance_type
    day  = var.mysql_resources.data.maintenance_day
    hour = var.mysql_resources.data.maintenance_hour
  }

  backup_window_start {
    hours   = var.mysql_resources.data.backup_hour
    minutes = var.mysql_resources.data.backup_min
  }

  host {
    zone      = yandex_vpc_subnet.private-a.zone
    subnet_id = yandex_vpc_subnet.private-a.id
    priority = 1
  }

  host {
    zone      = yandex_vpc_subnet.private-b.zone
    subnet_id = yandex_vpc_subnet.private-b.id
    priority = 50
  }
}