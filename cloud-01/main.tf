### Create vpc and vpc subnet
resource "yandex_vpc_network" "netolab" {
  name        = var.net_name
  description = var.net_desc
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = var.network.pub.v4_cidr_blocks
  name           = var.network.pub.name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netolab.id
}

resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = var.network.priv.v4_cidr_blocks
  name           = var.network.priv.name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netolab.id
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

### Create route table

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.netolab.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}

### Create NAT

data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}

resource "yandex_compute_disk" "boot-disk-nat" {
  name     = var.vms_resources.nat.disk_name
  type     = var.vms_resources.nat.disk_type
  zone     = var.default_zone
  size     = var.vms_resources.nat.disk_size
  image_id = var.nat_image_id
}

resource "yandex_compute_instance" "nat-instance" {
  name        = var.nat_vm_name
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    core_fraction = var.vms_resources.nat.core_fraction
    cores         = var.vms_resources.nat.cores
    memory        = var.vms_resources.nat.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-nat.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.vms_resources.nat.ip_address
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${local.ubukey}"
    user-data          = data.template_file.cloudinit.rendered
  }
}

### Create VM in public

resource "yandex_compute_image" "ubuntu" {
  source_family = var.vm_os_family
}

resource "yandex_compute_disk" "boot-disk-ubuntu-pub" {
  name     = var.vms_resources.vm.disk_name
  type     = var.vms_resources.vm.disk_type
  zone     = var.default_zone
  size     = var.vms_resources.vm.disk_size
  image_id = yandex_compute_image.ubuntu.id
}

resource "yandex_compute_instance" "pub-vm" {
  name        = var.pub_vm_name
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    core_fraction = var.vms_resources.vm.core_fraction
    cores         = var.vms_resources.vm.cores
    memory        = var.vms_resources.vm.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ubuntu-pub.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${local.ubukey}"
    user-data          = data.template_file.cloudinit.rendered
  }
}


### Create VM in private network

resource "yandex_compute_disk" "boot-disk-ubuntu-priv" {
  name     = "${var.vms_resources.vm.disk_name}-2"
  type     = var.vms_resources.vm.disk_type
  zone     = var.default_zone
  size     = var.vms_resources.vm.disk_size
  image_id = yandex_compute_image.ubuntu.id
}

resource "yandex_compute_instance" "priv-vm" {
  name        = var.priv_vm_name
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    core_fraction = var.vms_resources.vm.core_fraction
    cores         = var.vms_resources.vm.cores
    memory        = var.vms_resources.vm.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ubuntu-priv.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${local.ubukey}"
    user-data          = data.template_file.cloudinit.rendered
  }
}
