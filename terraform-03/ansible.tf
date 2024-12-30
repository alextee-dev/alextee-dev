
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { webservers = yandex_compute_instance.platform, databases = yandex_compute_instance.platform2, storage = yandex_compute_instance.platform3 })

  filename = "${abspath(path.module)}/hosts.ini"
}
