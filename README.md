# Создание сертификата пользователя для OCServ
## Подготовка:
Установите `certtool`:
```bash
sudo apt install gnutls-bin
```
Скачайте скрипт:
```bash
git clone https://github.com/marginalex2001/OCServ_CA_Cert.git
cd OCServ_CA_Cert
```
Задайте права доступа для запуска скриптов:
```bash
chmod +x Create_CA.sh
chmod +x Create_User_Cert.sh
```
Войдите под суперпользователем:
```bash
sudo -s
```
## Установка:
Запустите скрипт для создания сертификата ЦА:
```
./Create_CA.sh
```
Введите данные:

| Your organization | Название организации (может быть любым) |
|---|---|
| Certificate owner | Владедец сертификата |
| Certificate serial number | Число, например 001 |
| Expiration date | Кол-во дней до истечения (при значении -1 — без срока действия) |
## Создание сертификата пользователя:
Запустите скрипт для создания сертификата ЦА:
```
./Create_User_Cert.sh
```
> [!NOTE]
> Для пользователей Huawei и IOS используйте флаг `-A`:
> ```
> ./Create_User_Cert.sh -A
> ```


Введите данные:

| Your organization | Название организации (которое использовалось при создании сертификата ЦА) |
|---|---|
| Username | Username пользователя в OCServ |
| Common name of the certificate owner | Имя пользователя |
| Expiration date | Кол-во дней до истечения (при значении -1 — без срока действия) |
|Name for the key|Имя ключа|
|Password|Пароль для импорта|


# Установка сертификата:
Чтобы скачать сертификат на устройстве клиента выполните:
```bash
scp -P<Порт (по умолчанию 22)> <user>@<IP-address>:/etc/ocserv/ssl/user-cert/<Username>/<Username>.p12 .
```


Установите в конфигурации `/etc/ocserv/ocserv.conf` следующие параметры:
```bash
enable-auth = "plain[passwd=/etc/ocserv/ocpasswd]"
auth = "certificate"
```