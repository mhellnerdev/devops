#!/bin/bash

sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo systemctl disable firewalld --now
sudo setenforce 0
sudo sed -i 's/SELINUX=enforced/SELINUX=disabled/g' /etc/selinux/config
# sudo init 0 
sudo hostnamectl set-hostname awx-stream
vim /etc/hosts
sudo init 6

