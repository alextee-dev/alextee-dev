resource "yandex_mdb_mysql_database" "mysql_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = var.mysql_db.db.name
}

resource "yandex_mdb_mysql_user" "db_user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = var.mysql_db.db.user
  password   = "qwerty321"
  permission {
    database_name = yandex_mdb_mysql_database.mysql_db.name
    roles         = ["ALL"]
  }
}