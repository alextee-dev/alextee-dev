# Создание Container Registry.
resource "yandex_container_registry" "default" {
  name      = var.registry_name
  folder_id = var.folder_id
}

resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = yandex_container_registry.default.id
  role        = var.registry_role

  members = [
    var.registry_member,
  ]
}
