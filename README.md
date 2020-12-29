# xeniaweber_infra
xeniaweber Infra repository
## Homework 4
## Дано
- testapp_IP - 130.193.50.70
- teastapp_port - 9292
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
