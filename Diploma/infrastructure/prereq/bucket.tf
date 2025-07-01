# Создание бакета

resource "yandex_storage_bucket" "bucket" {
  depends_on = [ yandex_resourcemanager_folder_iam_member.storage-admin ]
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.bucket.data.name
  max_size              = var.bucket.data.max_size
  default_storage_class = var.bucket.data.default_storage_class
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}