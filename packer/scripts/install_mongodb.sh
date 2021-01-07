#!/bin/bash

# Adding key and repozitory MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# Updating apt
apt-get -y update
sleep 20

# Installing MongoDB
apt-get install -y mongodb-org

# Starting MongoDB
systemctl start mongod

# Enabling MongoDB
systemctl enable mongod

# Checking status MongoDB
#if (systemctl -q is-active mongod)
#	then
#	echo "Mongodb is active"
#	exit 1
#fi

