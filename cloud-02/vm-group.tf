# Create a new Compute Instance Group (IG)

resource "yandex_compute_instance_group" "group1" {
  name                = var.vm_group_resources.group1.name
  folder_id           = var.folder_id
  service_account_id  = var.service_account_id
  deletion_protection = false
  instance_template {
    platform_id = var.vm_platform
    resources {
      memory = var.vm_group_resources.group1.memory
      cores  = var.vm_group_resources.group1.cores
    }
    boot_disk {
      initialize_params {
        image_id = var.vm_group_resources.group1.image_id
        size     = var.vm_group_resources.group1.disk_size
      }
    }
    network_interface {
      network_id = yandex_vpc_network.netolab.id
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat = true
    }
    metadata = {
        ssh-keys           = "${local.ubukey}"
        user-data          = data.template_file.cloudinit.rendered
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["${var.default_zone}"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  health_check {
    healthy_threshold = 2
    interval = 2
    timeout = 1
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }
  }

  ### NLB

  # load_balancer {
  #   target_group_name        = var.balancer.nlb.target_group_name
  # }

  ### Application Load Balancer

  application_load_balancer {
    target_group_name        = var.balancer.alb.target_group_name
  }
}

### NLB

# resource "yandex_lb_network_load_balancer" "nlb-1" {
#   name = var.balancer.nlb.name

#   listener {
#     name = var.balancer.nlb.listener_name
#     port = 80
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }

#   attached_target_group {
#     target_group_id = yandex_compute_instance_group.group1.load_balancer.0.target_group_id

#     healthcheck {
#       name = "http"
#       http_options {
#         port = 80
#         path = "/"
#       }
#     }
#   }
# }


### Application Load Balancer

# Создание Application Load Balancer
resource "yandex_alb_load_balancer" "alb" {
  name               = var.balancer.alb.name
  network_id         = yandex_vpc_network.netolab.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = var.balancer.alb.listener_name
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.router.id
      }
    }
  }
}

# Создание HTTP роутера
resource "yandex_alb_http_router" "router" {
  name = var.balancer.alb.router_name
}

# Создание виртуального хоста
resource "yandex_alb_virtual_host" "virtual-host" {
  name           = var.balancer.alb.virtual_host_name
  http_router_id = yandex_alb_http_router.router.id

  route {
    name = var.balancer.alb.route_name
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
      }
    }
  }
}

# Создание группы бэкендов
resource "yandex_alb_backend_group" "backend-group" {
  name = var.balancer.alb.backend_group

  http_backend {
    name            = var.balancer.alb.http_backend
    weight          = 1
    port            = 80
    target_group_ids = [yandex_compute_instance_group.group1.application_load_balancer.0.target_group_id]
    
    healthcheck {
      timeout             = "3s"
      interval            = "5s"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      http_healthcheck {
        path = "/"
      }
    }
  }
}