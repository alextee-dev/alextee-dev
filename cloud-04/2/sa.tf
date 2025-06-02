# Service account
# Создание сервисного аккаунта

resource "yandex_iam_service_account" "sa-k8s" {
  name = var.sa-k8s.account.name
}

# Назначение роли сервисному аккаунту

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
 # Сервисному аккаунту назначается роль "k8s.clusters.agent".
 folder_id = var.folder_id
 role      = var.sa-k8s.account.role_agent
 member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = var.sa-k8s.account.role_puller
 member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
 # Сервисному аккаунту назначается роль "vpc.publicAdmin".
 folder_id = var.folder_id
 role      = var.sa-k8s.account.role_vpcadmin
 member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = var.folder_id
  role      = var.sa-k8s.account.role_enc
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_kms_symmetric_key" "key-sym" {
  name              = var.kms.key.name
  default_algorithm = var.kms.key.algorithm
}
