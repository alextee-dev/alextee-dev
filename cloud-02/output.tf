output "object_s3_uri" {
  value = "https://storage.yandexcloud.net/${yandex_storage_object.picture.bucket}/${yandex_storage_object.picture.key}"
}

output "alb_external_ip" {
  value = yandex_alb_load_balancer.alb.listener[*].endpoint[*].address[*].external_ipv4_address[*].address
  description = "External IP address of the ALB"
}
