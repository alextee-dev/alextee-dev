data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family1}"
}

resource "yandex_compute_disk" "boot-disk" {
  count = 7
  name     = "disk${count.index}"
  type     = "network-hdd"
  zone     = "${var.default_zone}"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu.image_id
}

resource "yandex_compute_instance" "platform1" {
  depends_on = [ yandex_compute_disk.boot-disk ]
  count = 7
  name        = "${var.vm_name}${count.index}"
  platform_id = "${var.vm_platform}"
  allow_stopping_for_update = true
  resources {
    cores         = "${var.vms_resources.ans1.cores}"
    memory        = "${var.vms_resources.ans1.memory}"
    core_fraction = "${var.vms_resources.ans1.core_fraction}"
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk["${count.index}"].id
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = "${var.subnet_id}"
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${local.ubukey}"
    user-data          = data.template_file.cloudinit.rendered
  }

}

resource "null_resource" "copy-test-file" {
depends_on = [ yandex_compute_instance.platform1 ]
  count = 7

  connection {
    type     = "ssh"
    host     = yandex_compute_instance.platform1["${count.index}"].network_interface[0].nat_ip_address
    user     = "kuber"
    private_key = file(var.vms_ssh_private_key)
  }

  provisioner "file" {
    source      = "~/.ssh/yc-ansible"
    destination = "/home/kuber/.ssh/private"
  }

}

data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}