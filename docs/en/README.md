# NOTES

- Useful scripts are located in `script/` directory;
- Kubernetes related files are located in `k8s` directory;
- Ansible related files are located in `ansible/` directory.

## PREREQUISITES

### IMPORT

0. Place `notes_app.zip` in `%USERPROFILE%\Desktop`
1. Run WSL

```bat
wsl.exe

```

2. Change directory to current Windows user

```sh
cd /mnt/c/Users/$USER

```

3. Create folder structure

```sh
mkdir -p "~/files/docs/stack/notes_app"

```

4. Unpack `notes_app.zip` into `~/files/docs/stack/notes_app`

```sh
unzip "notes_app.zip" -d "~/files/docs/stack/notes_app"

```

5. Cleanup

```sh
rm "notes_app.zip"

```

6. Change directory to `notes_app`

```sh
cd "~/files/docs/stack/notes_app"

```

7. Verify

```sh
ls -la

```

### SYSTEM

0. Update package definitions

```sh
sudo apt update

```

1. Upgrade packages

```sh
sudo apt upgrade -y

```

### DEPENDENCY INSTALL

2. Install dependencies

```sh
sudo apt install -y ca-certificates git make ansible curl default-jre default-jdk maven

```

### DOCKER INSTALL

0. Update package definitions

```sh
sudo apt update

```

1. Remove any potential conflicting packages

```sh
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)

```

2. Set permissions

```sh
sudo install -m 0755 -d /etc/apt/keyrings

```

3. Install GPG key

```sh
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc

```

4. Set permissions for GPG key

```sh
sudo chmod a+r /etc/apt/keyrings/docker.asc

```

5. Add repository to APT sources

```sh
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

```

6. Apply

```sh
sudo apt update

```

7. Install Docker

```sh
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

8. Verify

```sh
sudo docker run hello-world

```

9. Create `docker` group

```sh
sudo groupadd docker

```

10. Become member of `docker` group

```sh
sudo usermod -aG docker $USER

```

11. Reload current session

```sh
exit

```

12. Open `wsl.exe` from Windows;
13. Shutdown WSL.

```bat
wsl.exe --shutdown

```

14. Run WSL

```bat
wsl.exe

```

15. Verify

```sh
docker ps

```

### DOCKER LOGIN

1. Run login command

```sh
docker login

```

2. Enter user credentials such as email and password

## PROJECT

### MAKEFILE

0. Change directory to `notes_app`

```sh
cd "~/files/docs/stack/notes_app"

```

1. Execute build command

```sh
make build

```

2. Execute run command

```sh
make up

```

3. Allow execution of scripts

```sh
chmod +x script/*.sh

```

4. Test the API

```sh
./script/api_test.sh

```

### DOCKER HUB

0. Ensure you have `notes_app:latest` present in image list

```sh
docker images

```

1. Tag your `notes_app:latest` with your username

```sh
docker tag notes_app:latest $USER/notes-app:1.0

```

2. Push your image to the Docker Hub

```sh
docker push $USER/notes-app:1.0

```

### JENKINS

0. Change directory to `notes_app`

```sh
cd "~/files/docs/stack/notes_app"

```

1. Specify details

```sh
git config --global user.email $USER@localhost
git config --global user.name $USER

```

2. Initialize a Git repository

```sh
git init

```

3. Add all project files

```sh
git add .

```

4. Commit changes

```sh
git commit -m "init"

```

5. Deploy Jenkins

```sh
./script/jenkins_run.sh

```

6. Get Jenkins password

```sh
./script/jenkins_passwd.sh

```

7. Save password somewhere safe;
8. Open [Jenkins Dashboard](https://localhost:8081/) and login with username `admin` and password `admin123`;
9. Skip user creation;
10. Wait until Jenkins prepares the system;
11. Click on "New Item";
12. Name item "NotesApp";
13. Select "Pipeline" in "Select an item type";
14. Click "OK";
15. Scroll down to "Pipeline" section;
16. Set "Definition" to "Pipeline script from SCM";
17. Set "SCM" to "Git";
18. Set "Repository URL" to `file:///opt/repo`;
19. Click "Save";
20. Return to Dashboard;
21. Click on down arrow next to the "NotesApp";
22. Click "Build Now";
23. Wait until the build is finished.
