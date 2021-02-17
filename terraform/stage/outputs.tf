#output "external_ip_address_apps" {
#  value = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
#}
#output "external_ip_address_app2" {
#  value = yandex_compute_instance.app2.network_interface.0.nat_ip_address
#}
#output "external_ip_address_lb" {
#  value = yandex_lb_network_load_balancer.lb_app.listener.*.external_address_spec[0].*.address
#}
output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}
output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}
output "internal_ip_address_app" {
  value = module.app.internal_ip_address_app
}
output "internal_ip_address_db" {
  value = module.db.internal_ip_address_db
}
