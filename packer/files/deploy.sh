#!/bin/bash

# Updating apt
sudo apt-get -y  update
sleep 10

# Installing apt
sudo apt-get -y install git

# Cloning repository
git clone -b monolith https://github.com/express42/reddit.git

# Bundle install
cd reddit 
bundle install

# Make systemd unit
cat  > /etc/systemd/system/puma.service <<EOF
[Unit]
Description=Puma Service
After=network.target
Requires=mongod.service

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/usr/local/bin/puma

Restart=on-failure
RestartSec=40s

[Install]
WantedBy=multi-user.target
EOF

# Starting puma
systemctl start puma

# Enable puma
systemctl enable puma

# Status checking
if (systemctl -q is-active puma)
	then
	echo "Puma Service is active"
fi

