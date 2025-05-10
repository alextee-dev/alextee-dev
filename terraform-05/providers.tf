provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone1
  service_account_key_file = file("~/.authorized_key.json")
}

terraform {
  required_version = ">=1.8.4"

  backend "s3" {
    
    shared_credentials_files = ["~/.aws/credentials"]
    shared_config_files = [ "~/.aws/config" ]
    profile = "default"
    region="ru-central1"

    bucket     = "simple-bucket-4jz99zrd"
    key = "develop/terraform.tfstate"
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  endpoints ={
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g6ufvpo7vkirq2qlm7/etnnonv7vjgmpr8ph9v6"
    s3 = "https://storage.yandexcloud.net"
  }

    dynamodb_table              = "tsstate-dev"
  }

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.118.0"
    }
    template = {
      version = "~> 2"
      source  = "hashicorp/template"
    }
      random = {
      version = ">=3.6"
      source  = "hashicorp/random"
    }
  }
}
