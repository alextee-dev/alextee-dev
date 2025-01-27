# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = var.service_acc_name
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = var.service_acc_role
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

# Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.bucket.data.name
  max_size              = var.bucket.data.max_size
  default_storage_class = var.bucket.data.storage_class
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
  tags = {
    Env = var.bucket.data.env
  }
  grant {
    id          = yandex_iam_service_account.sa.id
    type        = var.bucket.data.grant_type
    permissions = var.bucket.data.permissions
  }
}

# Создание YDB
resource "yandex_ydb_database_serverless" "database1" {
  name                = var.db.data.name
  deletion_protection = var.db.data.deletion_protection

  serverless_database {
    storage_size_limit          = var.db.data.storage_size_limit
  }

}

resource "yandex_ydb_database_iam_binding" "editor" {
  database_id = yandex_ydb_database_serverless.database1.id
  role        = var.db.data.role

  members = [
    "serviceAccount:${yandex_iam_service_account.sa.id}"
  ]
}
