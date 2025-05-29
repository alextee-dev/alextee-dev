output "object_s3_uri" {
  value = "https://storage.yandexcloud.net/${yandex_storage_object.picture.bucket}/${yandex_storage_object.picture.key}"
}