# WebAnsible

Веб интерфейс для Ansible. Основной задачей данного приложения является предоставление графического интерфейса для более простого запуска плейбуков. 
Наличие форм и графических представлений объектов минимизирует вероятность ошибкок при определении области применения плейбука.

## Требования

Приложение разрабатывается и тестируется на ОС ubuntu 22.04, корректная работа на других версиях не гарантируется. 
Для работы всех функций необходимо установить в систему Ansible и внести следующие изменения в конфигурации:

* Экспортировать переменую окружения ANSIBLE_HOST_KEY_CHECKING со значением False
`export ANSIBLE_HOST_KEY_CHECKING=False`

* Установить пакет sshpass из оффициального репозитория
`sudo apt install sshpass`

* В файле /etc/ansible/ansible.cfg привести соответствующие строки к виду
```
[defaults]
host_key_checking = false
allow_world_readable_tmpfiles=true
```
В случае отсутствия файла его необходимо создать

* Установить пакеты bundle
`sudo apt install bundler`

## Установка

1. Склонировать проект из GitHub
`git clone https://github.com/NorthBridgeKholmsk/webansible.git`

2. Переместить каталог webansible с проектом в каталог /opt
`sudo mv webansible /opt/`

3. Скопировать unit файл сервиса в /etc/systemd/system
`sudo cp /opt/webansible/bin/webansible.service /etc/systemd/system/webansible.service`

4. Устанить записимости проекта
```
cd /opt/webansible
bundle install
```

5. Переименовать БД
`sudo mv /opt/webansible/db/development.sqlite3.bk /opt/webansible/db/development.sqlite3`

6. Добавить сервис в автозапуск и запустить
```
sudo systemctl daemon-reload
sudo systemctl enable webansible.service
sudo systemctl start webansible.service
```

7. Теперь Вы можете зайти в интерфейс из своего браузера по адресу http://ip_сервера:3000. Логин и пароль по умолчанию admin/admin