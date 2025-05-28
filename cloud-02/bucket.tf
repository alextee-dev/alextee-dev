# Создание сервисного аккаунта

resource "yandex_iam_service_account" "sa" {
  name = var.bucket.my.acc_name
}

# Назначение роли сервисному аккаунту

resource "yandex_resourcemanager_folder_iam_member" "bucket-admin" {
  folder_id = var.folder_id
  role      = var.bucket.my.acc_role
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

# Создание бакета с использованием статического ключа

resource "yandex_storage_bucket" "my-bucket" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.bucket.my.name
  max_size              = var.bucket.my.max_size
  default_storage_class = var.bucket.my.default_storage_class
  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
}

# Создание объекта

resource "yandex_storage_object" "picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.my-bucket.id
  key        = "picture.jpg"
  source     = "./picture.jpg"
}