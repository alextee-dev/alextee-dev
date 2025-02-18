
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",

  { webservers = yandex_compute_instance.platform, databases = yandex_compute_instance.platform2, storage = yandex_compute_instance.platform3 })

  filename = "${abspath(path.module)}/hosts.ini"
}

resource "null_resource" "web_hosts_provision" {
  depends_on = [yandex_compute_instance.platform, yandex_compute_instance.platform2, yandex_compute_instance.platform3]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command    = "> ~/.ssh/known_hosts &&eval $(ssh-agent) && cat ~/.ssh/ycservice | ssh-add -"
    on_failure = continue
  }

  provisioner "local-exec" {
     command = "sleep 120"
   }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/hosts.ini ${abspath(path.module)}/test.yml"
    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
  triggers = {
    always_run      = "${timestamp()}"
    always_run_uuid = "${uuid()}"

  }

}