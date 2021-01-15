resource "yandex_lb_target_group" "apps" {
  name = "apps-target-group"
  region_id = "ru-central1"
  folder_id = var.folder_id

  dynamic "target" {
    for_each = [for t in yandex_compute_instance.app: {
     address = t.network_interface.0.ip_address
  }
 ]
    content {
     subnet_id = var.subnet_id
     address = target.value.address
    }
  }
}    

#  target {
#    subnet_id = var.subnet_id
#    address   = yandex_compute_instance.app.network_interface.0.ip_address
#  }
#
#  target {
#    subnet_id = var.subnet_id
#    address   = yandex_compute_instance.app2.network_interface.0.ip_address
#  }
#}

resource "yandex_lb_network_load_balancer" "lb_app" {
  name = "lb-reddit"

  listener {
    name = "app-listener"
    port = 80
    target_port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.apps.id

    healthcheck {
      name = "http"
      http_options {
        port = 9292
      }
    }
  }
}

