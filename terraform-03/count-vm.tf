data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  depends_on = [yandex_compute_instance.platform2]

  count = 2

  name        = "${var.vm_def_name}${count.index+1}"
  platform_id = "${var.vm_platform}"
  resources {
    cores         = "${var.vm_web_resources.cores}"
    memory        = "${var.vm_web_resources.memory}"
    core_fraction = "${var.vm_web_resources.core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids  = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${local.ubukey}"
  }
}