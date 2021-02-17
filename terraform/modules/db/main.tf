resource "yandex_compute_instance" "db" {
  name = "${var.inf_env}-${var.name_module}-${var.name_app}"
  labels = {
    tags = "${var.inf_env}-${var.name_module}-${var.name_app}"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  
  connection {
    type  = "ssh"
    host  = yandex_compute_instance.db.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key)
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

#  provisioner "file" {
#    content = templatefile("${path.module}/mongod.tmpl", { db_int_addr = yandex_compute_instance.db.network_interface.0.ip_address })
#    destination = "/tmp/mongod.conf"
#  }
#
#  provisioner "remote-exec" {
#    script = "${path.module}/mdb_conf.sh"   
#  } 
}
