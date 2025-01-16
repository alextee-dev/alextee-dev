module "develop" {
  source = "./vpc"
  name = "${var.vpc_name}"
  zone = var.zone1
  v4_cidr_blocks = var.cidr1
}

module "marketing-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.develop.yandex_vpc_network.id
  subnet_zones   = [var.zone1]
  subnet_ids     = [module.develop.yandex_vpc_subnet.id]
  instance_name  = var.vm_marketing_name
  instance_count = 2
  image_family   = var.vm_os_family
  public_ip      = true

  labels = { 
    project = "marketing"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

module "analytics-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = module.develop.yandex_vpc_network.id
  subnet_zones   = [var.zone1]
  subnet_ids     = [module.develop.yandex_vpc_subnet.id]
  instance_name  = var.vm_analytics_name
  instance_count = 1
  image_family   = var.vm_os_family
  public_ip      = true

  labels = { 
    project = "analytics"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

data template_file "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file(var.vms_ssh_root_key)
  }
}