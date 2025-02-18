resource "yandex_compute_instance" "platform2" {
  for_each = {
    "0" = "main"
    "1" = "replica"
  }
  name        = "${var.each_vm[each.key]["vm_name"]}${each.value}"
  platform_id = "${var.vm_platform}"
  resources {
    cores         = "${var.each_vm[each.key]["cpu"]}"
    memory        = "${var.each_vm[each.key]["ram"]}"
    core_fraction = "${var.each_vm[each.key]["core_fraction"]}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size   = "${var.each_vm[each.key]["disk_volume"]}"
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