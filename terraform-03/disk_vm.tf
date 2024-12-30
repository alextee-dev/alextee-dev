resource "yandex_compute_disk" "disks" {
    count = 3
  name     = "${var.disk_properties.data.name}${count.index}"
  type     = "${var.disk_properties.data.type}"
  zone     = "${var.default_zone}"
  size     = "${var.disk_properties.data.size}"
}

resource "yandex_compute_instance" "platform3" {
  name        = "${var.each_vm[2]["vm_name"]}"
  platform_id = "${var.vm_platform}"
  resources {
    cores         = "${var.each_vm[2]["cpu"]}"
    memory        = "${var.each_vm[2]["ram"]}"
    core_fraction = "${var.each_vm[2]["core_fraction"]}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size   = "${var.each_vm[2]["disk_volume"]}"
    } 
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks
    content {
      disk_id     = secondary_disk.value["id"]
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