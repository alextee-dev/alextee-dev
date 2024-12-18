output "test" {

  value = [
    { VM1_name = yandex_compute_instance.platform.name },
    { VM1_ExternalIP = yandex_compute_instance.platform.network_interface[0].nat_ip_address },
    { VM1_fqdn = yandex_compute_instance.platform.fqdn },
    { VM2_name = yandex_compute_instance.platform2.name },
    { VM2_ExternalIP = yandex_compute_instance.platform2.network_interface[0].nat_ip_address },
    { VM2_fqdn = yandex_compute_instance.platform2.fqdn }

  ]
}