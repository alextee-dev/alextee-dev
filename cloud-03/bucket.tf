# Создание статического ключа доступа

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
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
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-sym.id
        sse_algorithm     = var.kms.key.sse_algorithm
      }
    }
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

# Create KMS Symmetric Key.

resource "yandex_kms_symmetric_key" "key-sym" {
  name              = var.kms.key.name
  default_algorithm = var.kms.key.algorithm
}