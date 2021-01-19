variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "fd8p76ercpknat9fdo89"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable inf_env {
  description = "Infrastructure environment"
}
variable name_module {
  description = "Module name"
}
variable name_app {
  description = "Service name"
}
variable db_ip {
  description = "MongoDB IP"
}
variable private_key {
  description = "Private key"
}

