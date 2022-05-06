#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker ubuntu
sudo apt install gnupg2 pass  -y
sudo service ufw stop
sudo apt install default-jre  -y
sudo apt install default-jdk  -y
sudo service ufw stop
