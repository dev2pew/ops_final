#!/usr/bin/env bash

set -euo pipefail

# UPDATE
sudo apt update
sudo apt upgrade -y

# INSTALL JAVA
sudo apt install openjdk-17-jdk -y

# VERIFY JAVA
java --version

# INSTALL MAVEN
sudo apt install maven -y

# VERIFY MAVEN
mvn --version

# INSTALL GRADLE
sudo apt install gradle -y

# VERIFY GRADLE
gradle -v

# INSTALL GIT
sudo apt instll git -y

# VERIFY GIT
git --version
