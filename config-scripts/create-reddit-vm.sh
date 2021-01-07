#!/bin/bash

yc compute instance create \
  --name reddit-app-hw5 \
  --hostname reddit-app-hw5 \
  --memory=4 \
  --create-boot-disk image-id=fd8p17a82e21mn7h9jtt,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub
