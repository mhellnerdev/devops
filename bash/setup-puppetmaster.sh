#!/bin/bash

# take input for hostname setup
echo This will setup this server as a puppet master node
echo What is the desired FQDN of this server?

read fqdn

# get private ip
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

# echo private ip into /etc/hosts
cat <<EOF | sudo tee -a /etc/hosts
$ip4      $fqdn      puppet
EOF

# set hostname
sudo hostnamectl set-hostname $fqdn

# download and install puppet5
sudo rpm -Uvh https://yum.puppetlabs.com/eol-releases/puppet5-release-el-7.noarch.rpm
sudo yum install puppetserver.noarch -y

# lower defauilt memory resource usage for puppetserver
sudo sed -i 's/Xms2g/Xms512m/g' /etc/sysconfig/puppetserver
sudo sed -i 's/Xmx2g/Xmx512m/g' /etc/sysconfig/puppetserver

# start puppet server
sudo systemctl start puppetserver
sudo systemctl enable puppetserver

