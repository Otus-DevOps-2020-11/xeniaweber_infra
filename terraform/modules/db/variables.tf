variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "fd8ft94u9p1k71mp5dup"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable inf_env {
  description = "Infractrucure environment"
}
variable name_module {
  description = "Module name"
}
variable name_app {
  description = "App name"
}
variable private_key {
  description = "Private key"
}
