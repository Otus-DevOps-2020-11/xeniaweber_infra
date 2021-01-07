#!/bin/bash

# Updating apt
sudo apt-get -y  update

# Installing apt
sudo apt-get -y install git

# Cloning repository
git clone -b monolith https://github.com/express42/reddit.git

# Bundle install
cd reddit 
bundle install

# Starting app
puma -d

# Checking port
echo "Check app port: "
ps aux | grep puma
