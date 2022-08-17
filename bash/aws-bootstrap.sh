#!/bin/bash

echo "########################################"
echo "####### Updating and Upgrading #########"
echo "########################################"

# update repos and packages
sudo apt update -y
sudo apt upgrade -y

echo "########################################"
echo "######### Setting Hostname #############"
echo "########################################"

# set hostname
sudo hostnamectl set-hostname nginx-prod

echo "########################################"
echo "####### Installing Python3 #############"
echo "########################################"

# python install
sudo apt install python3 -y
sudo apt install python-is-python3 -y
sudo apt install python3-pip -y
sudo apt install python3.8-venv -y
pip install --upgrade pip

echo "########################################"
echo "#### Setting up Git and Github Key #####"
echo "########################################"

# git config
git config --global user.email "mhellnerdev@gmail.com"
git config --global user.name "mhellnerdev"
ssh-keygen -t ed25519 -f ~/.ssh/github -C "mhellnerdev@gmail.com" -q -N ""
cat ~/.ssh/github.pub

# add and start ssh agent
eval $(ssh-agent -s) > /dev/null
ssh-add ~/.ssh/github 2> /dev/null

# add to .bashrc and output null
echo 'eval $(ssh-agent -s) > /dev/null' >> ~/.bashrc
echo 'ssh-add ~/.ssh/github 2> /dev/null' >> ~/.bashrc

echo "########################################"
echo "############# Nginx Setup ##############"
echo "########################################"

# nginx install
sudo apt install nginx -y
sudo systemctl enable nginx.service
sudo systemctl start nginx.service

echo "########################################"
echo "########### Docker Setup ###############"
echo "########################################"

# docker prerequisite install
echo "Installing Docker Prerequisites"
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# add gpg keys
echo "Adding GPG Keys for Docker Repo"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# add docker repo to sources
echo "Adding Repo to Sources List"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker
echo "Installing Docker"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# permissions for user account
echo "Setting up Permissions for Docker"
sudo groupadd docker
sudo usermod -aG docker ubuntu
newgrp docker

echo "########################################"
echo "####### Cloudwatch Agent Setup #########"
echo "########################################"

# download cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
# install cloudwatch agent
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
# # run Agent
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazoncloudwatch-agent/bin/config.json

# # certs
# sudo apt install certbot python3-certbot-nginx -y
# certbot --nginx --agree-tos -m mhellnerdev@gmail.com -d dev.incrediblenonsense.com -n

shutdown --reboot 1 "System rebooting in 1 minute"
sleep 90