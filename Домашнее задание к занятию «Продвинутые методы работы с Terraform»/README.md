**Задание 1**

![image](https://github.com/user-attachments/assets/66f4ee1e-2821-4149-9b10-c4404cc3c29f)

![image](https://github.com/user-attachments/assets/65df6a34-b2af-4c4d-b727-64875640e82a)

![image](https://github.com/user-attachments/assets/4b83bd10-2967-4cf2-8230-4f8a5395ae5c)


**Задание 2**

![image](https://github.com/user-attachments/assets/a9e747f4-41cd-4466-84df-08448f4892d1)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.135.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.develop_sub](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `null` | no |
| <a name="input_v4_cidr_blocks"></a> [v4\_cidr\_blocks](#input\_v4\_cidr\_blocks) | n/a | `list(string)` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_yandex_vpc_network"></a> [yandex\_vpc\_network](#output\_yandex\_vpc\_network) | n/a |
| <a name="output_yandex_vpc_subnet"></a> [yandex\_vpc\_subnet](#output\_yandex\_vpc\_subnet) | n/a |

**Задание 3**

![image](https://github.com/user-attachments/assets/f9d645e0-0e74-48fb-bb94-9abe81969e67)

![image](https://github.com/user-attachments/assets/79bec24e-484f-4cd0-9a79-ff05ba913362)

**Задание 4**

main.tf

```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = var.prod_name
  name = var.prod_name
  subnets = var.vpc_prod
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = var.dev_name
  name = var.dev_name
  subnets = var.vpc_dev
}
```

variables.tf

```
variable "vpc_prod" {
  description = "List of subnets with zones and CIDR blocks"
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  default = [
    {
      zone = "ru-central1-a"
      cidr = ["10.0.1.0/24"]
    },
    {
      zone = "ru-central1-b"
      cidr = ["10.0.2.0/24"]
    },
    {
      zone = "ru-central1-d"
      cidr = ["10.0.3.0/24"]
    }
  ]
}

variable "vpc_dev" {
  description = "List of subnets with zones and CIDR blocks"
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  default = [
    {
      zone = "ru-central1-a"
      cidr = ["10.0.1.0/24"]
    }
  ]
}

variable "prod_name" {
  type        = string
  default     = "prod"
}

variable "dev_name" {
  type        = string
  default     = "dev"
}
```

./vpc/main.tf

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_sub" {
  for_each = { for subnet in var.subnets : subnet.zone => subnet }
  name           = "${var.name}_${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = each.value.cidr
}
```

./vpc/variables.tf

```
variable "name" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}

variable "v4_cidr_blocks" {
  type    = list(string)
  default = null
}

variable "env_name" {
  type    = string
  default = null
}

variable "subnets" {
  type = list(object({
    zone = string
    cidr = list(string)
  }))

}
```

![image](https://github.com/user-attachments/assets/76dd91ec-72b3-42dd-af17-8e2e000e8f98)

![image](https://github.com/user-attachments/assets/99cdbc94-3afa-4478-b9a9-7d1f8a3d983c)

