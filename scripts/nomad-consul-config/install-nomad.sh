#!/bin/bash
sudo apt-get update && \
  sudo apt-get install wget gpg coreutils
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install nomad

sudo mkdir -p /etc/nomad.d
sudo chmod 700 /etc/nomad.d
sudo cp nomad.hcl /etc/nomad.d
sudo cp nomad.service /etc/systemd/system/
sudo mkdir -p /opt/nomad


