resource "yandex_vpc_network" "develop-a" {
  name = var.vpc_name1
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name1
  zone           = var.default_zone-a
  network_id     = yandex_vpc_network.develop-a.id
  v4_cidr_blocks = var.default_cidr-a
}

resource "yandex_vpc_network" "develop-b" {
  name = var.vpc_name2
}
resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name2
  zone           = var.default_zone-b
  network_id     = yandex_vpc_network.develop-b.id
  v4_cidr_blocks = var.default_cidr-b
}


data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_web_os_family}"
}
resource "yandex_compute_instance" "platform" {
  name        = "${local.web_name}"
  platform_id = "${var.vm_web_platform}"
  resources {
    cores         = "${var.vms_resources.web.cores}"
    memory        = "${var.vms_resources.web.memory}"
    core_fraction = "${var.vms_resources.web.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${var.vms_meta.data.ssh-keys}"
  }

}

resource "yandex_compute_instance" "platform2" {
  name        = "${local.db_name}"
  platform_id = "${var.vm_db_platform}"
  zone        = "${var.vm_db_zone}"
  resources {
    cores         = "${var.vms_resources.db.cores}"
    memory        = "${var.vms_resources.db.memory}"
    core_fraction = "${var.vms_resources.db.core_fraction}"
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
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = "${var.vms_meta.data.serial-port-enable}"
    ssh-keys           = "${var.vms_meta.data.ssh-keys}"
  }

}