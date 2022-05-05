#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo service ufw stop
sudo apt install default-jre
sudo apt install default-jdk
sudo service ufw stop
