terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

resource "yandex_mdb_mysql_database" "QWERTY" {
  cluster_id = var.cluster_id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "testuser" {
  cluster_id = var.cluster_id
  name       = var.db_user
  password   = var.db_password
  permission {
    database_name = yandex_mdb_mysql_database.QWERTY.name
    roles         = ["ALL"]
  }
}