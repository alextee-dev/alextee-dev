# Создание сервисного аккаунта

resource "yandex_iam_service_account" "sa" {
  name = var.sa.account.name
}

resource "yandex_iam_service_account_key" "sa-key" {
  service_account_id = yandex_iam_service_account.sa.id
  key_algorithm     = var.sa.account.key_algorithm
}

# Создание файла авторизации

resource "local_file" "auth_key" {
  content = jsonencode({
    id                 = yandex_iam_service_account_key.sa-key.id
    service_account_id = yandex_iam_service_account.sa.id
    created_at         = yandex_iam_service_account_key.sa-key.created_at
    key_algorithm      = yandex_iam_service_account_key.sa-key.key_algorithm
    public_key         = yandex_iam_service_account_key.sa-key.public_key
    private_key        = yandex_iam_service_account_key.sa-key.private_key
  })
  filename        = var.sa.account.key_file_path
  file_permission = var.sa.account.key_file_permission
}

# Создание статического ключа доступа

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

resource "local_file" "backend_credentials" {
  content  = <<-EOT
    [profile1]
    aws_access_key_id = ${yandex_iam_service_account_static_access_key.sa-static-key.access_key}
    aws_secret_access_key = ${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}
  EOT
  filename = var.sa.account.static_key_file_path
  file_permission = var.sa.account.key_file_permission
}

# Назначение роли сервисному аккаунту

resource "yandex_resourcemanager_folder_iam_member" "vpc-admin" {
 folder_id = var.folder_id
 role      = var.sa.account.role_vpcadmin
 member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "storage-admin" {
 folder_id = var.folder_id
 role      = var.sa.account.role_storageadmin
 member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "compute-admin" {
 folder_id = var.folder_id
 role      = var.sa.account.role_computeadmin
 member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}