data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "${var.vm_os_family}"
}

resource "yandex_compute_instance" "cicd" {
  name        = var.vms_resources.cicd.name
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    core_fraction = var.vms_resources.cicd.core_fraction
    cores         = var.vms_resources.cicd.cores
    memory        = var.vms_resources.cicd.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources.cicd.disk_size
      type     = var.vms_resources.cicd.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-a.id
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${local.ubukey}"
    user-data          = data.template_file.cloudinit.rendered
  }
}


resource "yandex_compute_instance" "cicd-agent" {
  name        = var.vms_resources.cicd-agent.name
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    core_fraction = var.vms_resources.cicd-agent.core_fraction
    cores         = var.vms_resources.cicd-agent.cores
    memory        = var.vms_resources.cicd-agent.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources.cicd-agent.disk_size
      type     = var.vms_resources.cicd-agent.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-a.id
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${local.ubukey}"
    user-data          = data.template_file.cloudinit.rendered
  }
}

### Создание inventory файла

data "template_file" "inventory-cicd" {
  template = file("inventory-cicd.tpl")

  vars = {
    cicd_nat_ip = yandex_compute_instance.cicd.network_interface[0].nat_ip_address
    cicd-agent_nat_ip = yandex_compute_instance.cicd-agent.network_interface[0].nat_ip_address
  }
}

resource "local_file" "inventory-cicd" {
  filename = var.inventory-cicd_path
  content  = data.template_file.inventory-cicd.rendered
}