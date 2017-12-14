#!/bin/bash

# ---
# Deploy Docker with Docker-Compose on CentOS7
# V 0.1 - 2017-12-13 Initial version
# ---

LUID=$(id -u)
if [ $LUID -eq 0 ]; then
  error "Error : you must use an user not the root account"
  exit 1
fi

if [ -z $1 ]; then
  echo "Error : You must specify an user name on the command line."
  exit 1
fi

if [ -z `grep ${1} /etc/passwd` ]; then
  echo "Error : The user does not exist."
  exit 1
fi

sudo groupadd docker

sudo timedatectl set-timezone Europe/Paris
sudo timedatectl

sudo yum install -y ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd

# Install tools
sudo yum install -y git wget

# Suppression des anciennes versions
sudo yum remove docker docker-common docker-selinux docker-engine
# Installation outils
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo usermod -aG docker ${1}
 
# Starting Docker
sudo systemctl start docker

# Testing Docker with the Hello-World docker
docker run hello-world

# Install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "*** End of process"
