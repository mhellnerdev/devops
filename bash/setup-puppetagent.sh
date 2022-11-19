#!/bin/bash

# take input for hostname setup
echo This will setup this server as a puppet agent node
echo What is the desired FQDN of this server?

read fqdn

echo What is the IP of the master server?

read masterip

echo What is the FQDN of the master server?

read masterfqdn

# get private ip
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

# echo private ip into /etc/hosts
cat <<EOF | sudo tee -a /etc/hosts
$ip4      $fqdn
$masterip   $masterfqdn     puppet
EOF

# set hostname
sudo hostnamectl set-hostname $fqdn

# download and install puppet7
sudo rpm -Uvh http://yum.puppet.com/puppet7-release-el-7.noarch.rpm
sudo yum install puppet-agent -y

cat <<EOF | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
[main]
certname = $fqdn
server = $masterfqdn
EOF


# start puppet server
sudo systemctl start puppet
sudo systemctl enable puppet

# create symlink to puppet agent in exisitng $PATH location
sudo ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet

# verify communication between agent and master. perform after signing cert on master
# sudo puppet agent -tv