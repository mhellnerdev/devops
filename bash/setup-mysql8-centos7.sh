#!/bin/bash

# install mysql on centos7
sudo yum update -y
sudo yum install wget -y
wget https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
sudo yum localinstall mysql80-community-release-el7-1.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum update
sudo yum install mysql-community-server -y

