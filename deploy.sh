#!/bin/bash

# Updating apt
sudo apt-get update

# Installing apt
sudo apt-get install git

# Cloning repository
git clone -b monolith https://github.com/express42/reddit.git

# Bundle install
cd reddit 
bundle install

# Starting app
cd reddit
puma -d

# Checking port
echo "Check app port: "
ps aux | grep puma
