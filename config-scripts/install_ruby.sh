#!/bin/bash

# Updating apt
sudo apt-get -y update
# Installing ruby && bundler
sudo apt install -y ruby-full ruby-bundler build-essential

# Checking versions
echo "Ruby version: "
ruby -v
echo "Bundler version: "
bundler -v
