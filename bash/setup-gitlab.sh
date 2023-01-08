#!/bin/bash

# Setup SSH key login
mkdir ~/.ssh
chmod 700 ~/.ssh

# cat pub key into authorized_keys
cat <<EOF | tee ~/.ssh/authorized_keys

EOF

# Set correct permissions for sshd
chmod 600 ~/.ssh/authorized_keys

# Turn off password authentication
sudo sed -i 's/#   PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/ssh_config && cat /etc/ssh/ssh_config

sudo systemctl restart sshd && sudo systemctl status sshd

sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo dnf install tar -y
sudo dnf install git -y
sudo systemctl disable firewalld --now
sudo dnf install open-vm-tools -y
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config && cat /etc/selinux/config
# sudo init 0 
sudo hostnamectl set-hostname gitlab
sudo vim /etc/hosts
sudo init 6