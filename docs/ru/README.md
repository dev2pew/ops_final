# NOTES

- Полезные скрипты находятся в директории `scripts/`;
- Файлы относящиеся к Kubernetes расположены в директории `k8s`;
- Файлы относящиеся к Ansible расположены в директории `ansible`.

## ПОДГОТОВКА

### ИМПОРТ

0. Сохраните архив `notes_app.zip` в директории `%USERPROFILE%\Desktop` (Рабочий стол)
1. Запустите WSL

```bat
wsl.exe

```

2. Смените директорию на данного пользователя Windows

```sh
cd /mnt/c/Users/$USER

```

3. Подготовьте структуру папок для проекта

```sh
mkdir -p "~/files/docs/stack/notes_app"

```

4. Распакуйте архив `notes_app.zip` в директорию `~/files/docs/stack/notes_app`

```sh
unzip "notes_app.zip" -d "~/files/docs/stack/notes_app"

```

5. Очистка

```sh
rm "notes_app.zip"

```

6. Смените директорию на `notes_app`

```sh
cd "~/files/docs/stack/notes_app"

```

7. Проверка

```sh
ls -la

```

### SYSTEM

0. Обновите записи APT

```sh
sudo apt update

```

1. Обновите пакеты

```sh
sudo apt upgrade -y

```

### DEPENDENCY INSTALL

2. Установите зависимости

```sh
sudo apt install -y ca-certificates git make ansible curl default-jre default-jdk maven

```

### DOCKER INSTALL

0. Обновите записи APT

```sh
sudo apt update

```

1. Удалите потенциальные конфликтующие пакеты

```sh
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)

```

2. Установите разрешения

```sh
sudo install -m 0755 -d /etc/apt/keyrings

```

3. Установите GPG ключ

```sh
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc

```

4. Установите разрешения для GPG ключа

```sh
sudo chmod a+r /etc/apt/keyrings/docker.asc

```

5. Добавьте репозиторию в источники APT

```sh
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

```

6. Применить

```sh
sudo apt update

```

7. Установите Docker

```sh
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

8. Проверка

```sh
sudo docker run hello-world

```

9. Создайте группу `docker`

```sh
sudo groupadd docker

```

10. Станьте участником группы `docker`

```sh
sudo usermod -aG docker $USER

```

11. Перезагрузите сессию

```sh
exit

```

12. Откройте командную строку из Windows;
13. Завершите работу WSL.

```bat
wsl.exe --shutdown

```

14. Запустите WSL заново

```bat
wsl.exe

```

15. Проверка

```sh
docker ps

```

### DOCKER LOGIN

1. Запустите команду для входа в Docker

```sh
docker login

```

2. Введите свои данные такие как почта и пароль

## PROJECT

### MAKEFILE

0. Смените директорию на `notes_app`

```sh
cd "~/files/docs/stack/notes_app"

```

1. Запустите команду для сборки проекта

```sh
make build

```

2. Запустите команду для запуска проекта

```sh
make up

```

3. Выдайте права на запуск скриптов

```sh
chmod +x scripts/*.sh

```

4. Проверить API проекта

```sh
./scripts/api_test.sh

```

### DOCKER HUB

0. Убедитесь что у вас присутствует `notes_app:latest` в списке образов

```sh
docker images

```

1. Пометьте своим именем пользователя образ `notes_app:latest`

```sh
docker tag notes_app:latest $USER/notes-app:1.0

```

2. Загрузите свой образ на Docker Hub

```sh
docker push $USER/notes-app:1.0

```

### JENKINS

0. Смените директорию на `notes_app`

```sh
cd "~/files/docs/stack/notes_app"

```

1. Введите свою информацию как показано ниже

```sh
git config --global user.email $USER@localhost
git config --global user.name $USER

```

2. Инициализируйте новую Git репозиторию

```sh
git init

```

3. Добавьте все файлы в проекте

```sh
git add .

```

4. Зафиксируйте изменения

```sh
git commit -m "init"

```

5. Разверните Jenkins

```sh
./scripts/jenkins_run.sh

```

6. Посмотреть пароль доступа от Jenkins

```sh
./scripts/jenkins_passwd.sh

```

7. Сохраните пароль в надёжном месте;
8. Откройте [Меню управления Jenkins](https://localhost:8081/) и войдите в учётную запись администратора с именем пользователя `admin` и паролем `admin123`;
9. Пропустите этап создания пользователя;
10. Подождите пока Jenkins завершит настройку системы;
11. Нажмите на "New Item";
12. Назовите запись "NotesApp";
13. Выберите "Pipeline" в меню "Select an item type";
14. Нажмите "OK";
15. Прокрутите вниз, где расположен "Pipeline";
16. Установите "Definition" на значение "Pipeline script from SCM";
17. Установите "SCM" на значение "Git";
18. Установите "Repository URL" на значение `file:///opt/repo`;
19. Нажмите "Save";
20. Вернитесь на главное меню;
21. Наведите мышку на стрелочку рядом с "NotesApp" и нажмите на неё;
22. Выберите "Build Now" из списка;
23. Подождите пока Jenkins завершит процесс сборки.
