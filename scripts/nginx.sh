#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo apt update
sudo apt install nginx -y
systemctl enable nginx
systemctl start nginx
service ufw stop
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo service ufw stop
