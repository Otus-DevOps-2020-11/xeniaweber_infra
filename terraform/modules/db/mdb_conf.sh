#!/bin/bash

sudo cp /etc/mongod.conf /etc/mongod.conf.bck
sudo mv /tmp/mongod.conf /etc/mongod.conf
sudo systemctl restart mongod
