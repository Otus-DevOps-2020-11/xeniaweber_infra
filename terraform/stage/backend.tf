terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-xw"
    region     = "ru-central1"
    key        = "stage/terraform.tfstate"
    access_key = "TzwwwHB7S2fjgkjkhgjkh"
    secret_key = "YmgIKReTrgFfgjfkjgkfjgTfpF13"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
