provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
  subnet_id       = var.subnet_id
  inf_env         = var.inf_name
  name_module     = var.mdl_app
  name_app        = var.nmapp
  db_ip           = module.db.internal_ip_address_db
  private_key     = var.private_key_path
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
  subnet_id       = var.subnet_id
  inf_env         = var.inf_name
  name_module     = var.mdl_db
  name_app        = var.nmapp
  private_key     = var.private_key_path
}
