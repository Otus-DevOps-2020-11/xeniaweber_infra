#!/bin/bash

# Adding key and repozitory MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# Updating apt
sudo apt-get -y update

# Installing MongoDB
sudo apt-get install -y mongodb-org

# Starting MongoDB
sudo systemctl start mongod

# Enabling MongoDB
sudo systemctl enable mongod

# Checking status MongoDB
sudo systemctl status mongod

