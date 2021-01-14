# xeniaweber_infra
xeniaweber Infra repository
## Homework 6
### Самостоятельная работа 
- Опредляю input переменную для приватного ключа. Для этого в [variables.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/variables.tf) добавляю следующую запись:
```console
variable private_key_path {
  description = "Path to the private key"
}
```
А в *terraform.tfvars* добавляю следующую запись:
```console
private_key_path         = "~/.ssh/ubuntu"
```
- Определяю input переменную для задания зоны в ресурсе *"yandex_compute_instance" "app"*, в файле [main.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/main.tf) добавляю следующую запись для данного ресура:
```console
   zone = var.zone
```
- Так как [.gitigonre](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/.gitignore) не позволит закоммитить *terraform.tfvars*, файл скопирован с названием [terraform.tfvars.example](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/terraform.tfvars.example) и закоммичен в таком виде.
### Задание с **
- Создан HTTP балансировщик, для его создания написан файл [lb.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/lb.tf)
Для начала создана целевая группа, состоящая из облачных ресурсов, по которым будет распределяться входящий трафик. На данный момент такой облачный ресурс - инстанс, создание которого описано в [main.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/main.tf). Для создания целевой группы с инстансом использую ресурс *"yandex_lb_target_group"* :
```console
resource "yandex_lb_target_group" "apps" { 
  name = "apps-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = var.subnet_id
    address   = yandex_compute_instance.app.network_interface.0.ip_address
 }
}
```
Далее использован ресурс *"yandex_lb_network_load_balancer"* для создания самого балансировщика (*listener*) и прикрепления к нему целевой группы (*attached_target_group*), в настройках балансировщика можно также заметить перенаправление трафика с 80 порта (*port = 80*) на 9292 порт для всех инстансов целевой группы (*target_port = 9292*) и проверку доступности инстансов по 9292 порту (*healthcheck*):
```console
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
```
Для IP-адреса балансировщика определена output перемененна, для этого в [outputs.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/outputs.tf) внесена следующая запись:
```console
output "external_ip_address_lb" {
  value = yandex_lb_network_load_balancer.lb_app.listener.*.external_address_spec[0].*.address
}
```
- В [main.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/main.tf) добавлен код для создания второго инстанса reddit-app2 по подобию кода для первого инстанса. На данный момент эта часть кода закомментирована в файле. Также инстанс reddit-app2 по подобию reddit-app был добавлен в целевую группу в файле [lb.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/lb.tf) (эта часть кода тоже закомментирована) и была определенна output переменная для вывода публичного IP-адреса. Output переменна создана тоже по подобию переменной для первого инстанса и тоже на данный моменты закомментирована в файле [outputs.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/outputs.tf). 
Такой подход не очень удобен, так как кода становится слишком много и сам код просто дублируется. Если, к примеру, придется создавать 100 инстансов, на дублирование можно потратить очень много времени. Оптимизация такого процесса представлена в следующем пункте.
- Использую мета-параметр **count** для создания множества копий облачных ресурсов. Для начала была создана input переменная для **count**, в файле [variables.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/variables.tf) внесена следующая запись:
```console
variable appcount {
  description = "Value for count"
  default = 1
}
```
В файл [terraform.tfvars](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/terraform.tfvars.example) внесена следующая запись:
```console
appcount             = 1
```
И наконец в [main.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/main.tf) определен **count** для ресурса *"yandex_compute_instance" "app"*:
```console
resource "yandex_compute_instance" "app" {
  count = var.appcount
  name = "reddit-app${count.index + 1}"
  zone = var.zone
``` 
В секции *connection* так же значение для *host* приведенно к следующему виду: 
```console
host = self.network_interface.0.nat_ip_address
```
И для вывода списка IP-адресов созданных инстансов определенна output переменная в [outputs.tf](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/terraform-1/terraform/outputs.tf):
```console
output "external_ip_address_apps" {
  value = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
}
```
## Homework 5
- Шаблон параметризирован при помощи скрипта [variables.json](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/packer-base/packer/variables.json.examples)
- Из дополнительных опций параметризованы следующие:
```console
"disk_type": "network-ssd",
"zone": "ru-central1-a"
```
- Cоздания bake-образа с приложением:
    - Написан шаблон [immutable.json](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/packer-base/packer/immutable.json), в секцию *provisioners* добавлено выполнения скрипта deploy.sh
    - Внесены измнения в сркипт [deploy.sh](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/packer-base/packer/files/deploy.sh), в ходе которых создается systemd unit приложения (puma.service)
    - В результате с помощью packer создается образ, для которого в *immutable.json* указан  с *image_family* **redit-full**
    - Написан скрипт файл [create-reddit-vm.sh](https://github.com/Otus-DevOps-2020-11/xeniaweber_infra/blob/packer-base/config-scripts/create-reddit-vm.sh) для автоматического создания инстанса с использованием созданного образа **redit-full**. Для этого указан параметр для *image_id* - идентификатор образа   
- Ключ key.json остался у меня на локальном устройстве, дабы не храниться в публичном репозитории
## Homework 4
## Дано
- testapp_IP - 130.193.50.70
- teastapp_port - 9292
## Самостоятельное задание 
Были созданы bash скрипты для автоматической установки ruby. mongodb и приложения. Скрипты закоммичены в репозиторий как исполняемые файлы, для этого была использована следующая команда:
```console
git add --chmod=+x install_ruby.sh install_mongodb.sh deploy.sh
```
## Дополнительное задание
Для выполнения задания был создан скрипт с командами CLI для создания инстанса и файл с метаданными для выполнения скриптов, созданных в рамках самостоятельной работы. Для использования метаданных к ранее известным командам CLI была добавлена следующая:
```console
--metadata-from-file user-data=./metadata.yml
```

## Homework 3
## Дано
- bastion_IP - 84.201.133.93
- someintrenalhost_IP - 10.130.0.31
## Подключение к someinternalhost в одну строчку
1. Использование ключа **-J** для подключения к целевому хосту, установив вначале соединение с переходным хостом
```console
ssh -AJ appuser@<bastion_IP> appuser@<someinternalhost_IP>
```
2. Использование ключа **-t** для вызова псевдо-терминала, а именно выполнение команды на удаленном хосте. В данном случае на удаленном хосте *bastion* выполняю ssh подключение к *someinternalhost*
```console
ssh -At appuser@<bastion_IP> ssh appuser@<someintrenalhost_IP>
```
## Подключение по команде ssh someinternalhost
Для этого необходимо воспользоваться ssh алиасами. Мной были внесены следующие конфигурации в */etc/ssh/ssh_config*:
```console
# Настройки для хоста bastion
Host bastion    # Создаю алиас bastion
HostName 84.201.133.93 # IP адрес хоста, с которым ассоциируется данный алиас
User appuser    # Имя пользователя для ssh подключения
IdentityFile ~/.ssh/appuser # Пусть к файлу c приывтным ключом для аутенификации

# Настройка для хоста someinternalhost
Host someinternalhost    # Создаю алиас someinternalhost
HostName 10.130.0.31 # IP адрес хоста, с которым ассоциируется данный алиас
User appuser    # Имя пользователя для ssh подключения
IdentityFile ~/.ssh/appuser # Пусть к файлу c приывтным ключом для аутенификаци
ProxyCommand ssh -A bastion -W %h:%p    # Команда для связи с хостом. В данном случае подключаюсь к хосту через подключение к bastion по ssh
```
Теперь моя система знает что такое *bastion* и *someinternalhost*, а также как к этим хостам подключаться. Итого с локального устройства подключаюсь к *someinternalhost* при помощи следующей команды:
```console
ssh someintrenalhost
```
## Валидный сертификат для панели управления VPN-сервера
Использую сервис xip.io
1. В панели управления перехожу в Settings
2. В поле "Lets Encrypt Domain" вписываю - <bastion_IP>.xip.io и сохраняю настройки
3. В логах вижу:
```console
[autumn-stars-6641][2020-12-27 13:07:38,110][INFO] Verifying 84.201.133.93.xip.io...
[autumn-stars-6641][2020-12-27 13:07:40,037][INFO] 84.201.133.93.xip.io verified!
[autumn-stars-6641][2020-12-27 13:07:40,041][INFO] Signing certificate...
[autumn-stars-6641][2020-12-27 13:07:42,922][INFO] Certificate signed!
```
4. Перехожу в бразуере по заданному домену <bastion_IP>.xip.io, наблюдаю защищенное соединение по HTTPS
