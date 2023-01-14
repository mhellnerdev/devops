#!/bin/bash

# Setup SSH key login
mkdir /home/circlelabs/.ssh
chown circlelabs:circlelabs /home/circlelabs/.ssh
chmod 700 /home/circlelabs/.ssh

# cat pub key into authorized_keys
cat <<EOF | tee /home/circlelabs/.ssh/authorized_keys
<KEY_HERE>
EOF

# Set correct permissions for sshd
chown circlelabs:circlelabs /home/circlelabs/.ssh/authorized_keys
chmod 600 /home/circlelabs/.ssh/authorized_keys

# Turn off password authentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && sudo cat /etc/ssh/sshd_config
sudo systemctl restart sshd && sudo systemctl status sshd

# Package Installs
sudo dnf makecache --refresh
sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo dnf install tar -y
sudo dnf install git -y
sudo dnf install wget -y
sudo dnf install net-tools -y
sudo dnf install telnet -y
sudo dnf install nc -y
sudo dnf install open-vm-tools -y
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config && cat /etc/selinux/config
sudo vim /etc/hosts
sudo init 6

###############
## Terraform ##
###############

sudo dnf install -y dnf-plugins-core

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

sudo dnf -y install terraform