resource "yandex_compute_instance" "app" {
  name = "${var.inf_env}-${var.name_app}-${var.name_module}"

  labels = {
    tags = "${var.inf_env}-${var.name_app}-${var.name_module}"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  
  connection {
    type  = "ssh"
    host  = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key)
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  
  provisioner "file" {
    content = templatefile("${path.module}/puma.tmpl", { dp_int_addr = var.db_ip })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" { 
    script = "${path.module}/deploy.sh"
   }
}
