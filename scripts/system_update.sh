#!/usr/bin/env bash

set -euo pipefail

# UPDATE THE SYSTEM
sudo apt update
sudo apt upgrade -y

# INSTALL JAVA 17
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

