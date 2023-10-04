#!/bin/bash
sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl enable nomad
sudo systemctl start nomad
