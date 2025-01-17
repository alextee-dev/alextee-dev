# Модуль создания сети prod
module "vpc_prod" {
  source       = "./vpc"
  env_name     = var.prod_name
  name = var.prod_name
  subnets = var.vpc_prod
}

# Модуль создания сети dev
module "vpc_dev" {
  source       = "./vpc"
  env_name     = var.dev_name
  name = var.dev_name
  subnets = var.vpc_dev
}

# Модуль создания кластера managed MySQL
module "mysql" {
  source = "./mysql"
  name = var.cluster1_name
  network_id = module.vpc_prod.yandex_vpc_network.id
  subnet_id = module.vpc_prod.yandex_vpc_subnet.ru-central1-a.id
  HA = true
  
}

# Модуль создания БД и пользователя в кластере managed
module "mysql_db" {
  source = "./mysql_db"
  cluster_id = module.mysql.yandex_mdb_mysql_cluster.id
  db_name = var.db_managed_name
  db_user = var.db_managed_user
}

# Модуль создания кластера example MySQL
module "mysql_example" {
  source = "./mysql"
  name = var.cluster2_name
  network_id = module.vpc_prod.yandex_vpc_network.id
  subnet_id = module.vpc_prod.yandex_vpc_subnet.ru-central1-a.id
  HA = false
  
}

# Модуль создания БД и пользователя в кластере example
module "mysql_db_example" {
  source = "./mysql_db"
  cluster_id = module.mysql_example.yandex_mdb_mysql_cluster.id
  db_name = var.db_example_name
  db_user = var.db_example_user
}

data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}

