# providers.tf
terraform {
  required_version = ">=1.12.0"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}



terraform {
  
  backend "s3" {
    bucket  = "test-bucket-netology-homework"  # замените на имя вашего бакета
    key     = "terraform.tfstate"
    region  = "ru-central1"
    
    # Встроенный механизм блокировок (Terraform >= 1.6)
    use_lockfile = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    # Можно добавить явное указание профиля
    profile = "default"
  }
}

