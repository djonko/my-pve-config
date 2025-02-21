#!/bin/bash
sudo apt install apt-transport-https ca-certificates curl lsb-release gpg git nano wget openssh-server -y nfs-common

sudo curl -L https://www.ikus-soft.com/archive/minarca/public.key | sudo gpg --dearmor -o /usr/share/keyrings/minarca-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/minarca-keyring.gpg] https://nexus.ikus-soft.com/repository/apt-release-$(lsb_release -sc)/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/minarca.list > /dev/null
sudo apt update

sudo apt install minarca-server -y


