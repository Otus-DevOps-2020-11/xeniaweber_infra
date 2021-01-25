variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key.json"
}
variable private_key_path {
  description = "Path to the private key"
}
variable appcount {
  description = "Value for count"
  default     = 1
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "fd8p76fgfgfnat9fdo89"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "fd8ft9fgfgfk71mp5dup"
}
variable inf_name {
  description = "Infrastructure env name"
  default     = "stage"
}
variable mdl_app {
  description = "Module app name"
  default     = "app"
}
variable mdl_db {
  description = "Module db name"
  default     = "db"
}
variable nmapp {
  description = "App name"
  default     = "reddit"
}

