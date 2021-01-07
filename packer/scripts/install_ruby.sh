#!/bin/bash

# Updating apt
apt-get -y update
sleep 20
# Installing ruby && bundler
apt install -y ruby-full ruby-bundler build-essential

# Checking versions
#echo "Ruby version: "
#ruby -v
#echo "Bundler version: "
#bundler -v
