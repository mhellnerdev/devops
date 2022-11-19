#!/bin/bash

# take input for hostname setup
echo This will setup this server as a puppet master node
echo What is the desired FQDN of this server?

read fqdn

echo What is the IP of your test puppet agent?
read agentip

echo What is the FQDN of your puppet agent?
read agentfqdn

# get private ip
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

# echo private ip into /etc/hosts
cat <<EOF | sudo tee -a /etc/hosts
$ip4      $fqdn      puppet
$agentip    $agentfqdn
EOF

# set hostname
sudo hostnamectl set-hostname $fqdn

# download and install puppet7
sudo rpm -Uvh http://yum.puppet.com/puppet7-release-el-7.noarch.rpm
sudo yum install puppetserver.noarch -y

# reduce the default memory resource usage for puppetserver
sudo sed -i 's/Xms2g/Xms512m/g' /etc/sysconfig/puppetserver
sudo sed -i 's/Xmx2g/Xmx512m/g' /etc/sysconfig/puppetserver

# start puppet server
sudo systemctl start puppetserver
sudo systemctl enable puppetserver

# create symlink to puppetserver in exisitng $PATH location
sudo ln -s /opt/puppetlabs/bin/puppetserver /usr/bin/puppetserver

# sign cert from agent
# puppetserver ca sign --certname $agentfqdn

cat <<EOF | sudo tee /etc/puppetlabs/puppet/autosign.conf
*.circlelabs.sh
EOF