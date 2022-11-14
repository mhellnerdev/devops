#!/bin/bash

# install mysql on centos7
sudo yum update -y
sudo yum install wget -y
wget https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
sudo yum localinstall mysql80-community-release-el7-1.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum update
sudo yum install mysql-community-server -y
sudo systemctl start mysqld.service

sudo grep 'temporary password' /var/log/mysqld.log

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | mysql_secure_installation
      # current root password (emtpy after installation)
    y # Set root password?
    test1234 # new root password
    test1234 # new root password
    y # Remove anonymous users?
    y # Disallow root login remotely?
    y # Remove test database and access to it?
    y # Reload privilege tables now?
EOF