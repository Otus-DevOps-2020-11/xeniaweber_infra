terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-xw"
    region     = "ru-central1"
    key        = "prod/terraform.tfstate"
    access_key = "TzwwwHB7SsddsfsL6Q51UI"
    secret_key = "YmgIKReTrgFEokCehrgKTfpF1sfsU3pfs"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
