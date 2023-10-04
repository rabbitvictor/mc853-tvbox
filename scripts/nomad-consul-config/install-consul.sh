#!/bin/bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul

sudo mkdir -p /etc/consul.d
sudo chmod 700 /etc/consul.d
sudo cp consul.hcl /etc/consul.d
sudo cp consul.service /etc/systemd/system/
sudo mkdir -p /opt/consul