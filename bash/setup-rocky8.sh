#!/bin/bash

# Set hostname
echo "Enter hostname:"
read hostname
hostnamectl set-hostname $hostname

# Set up networking
echo "Enter IP address:"
read ip_address
echo "Enter netmask:"
read netmask
echo "Enter gateway:"
read gateway
echo "Enter network interface (e.g. eth0):"
ip link show | awk -F: '{print $2}'
read interface
echo "Enter DNS Servers seperated by a space:"
read dns_servers

nmcli device set ens192 managed yes
nmcli connection add type ethernet con-name ${interface}-connection ifname ens192
# nmcli connection add type ethernet con-name ens192-connection ifname ens192
nmcli connection modify ${interface}-connection ipv4.method manual ipv4.addresses ${ip_address}/${netmask} ipv4.gateway ${gateway} ipv4.dns "${dns_servers}"
# nmcli connection modify ens192-connection ipv4.method manual ipv4.addresses 10.10.100.63/24 ipv4.gateway 10.10.100.1 ipv4.dns "10.10.100.1 1.1.1.1"
nmcli connection up ens192-connection

# Set DNS servers
# echo "Enter DNS servers separated by a space:"
# read -a dns_servers
echo "nameserver ${dns_servers[0]}" > /etc/resolv.conf
for i in "${dns_servers[@]:1}"
do
echo "nameserver $i" >> /etc/resolv.conf
done

# Set search domains
echo "Enter search domains separated by a space:"
read -a search_domains
echo "search ${search_domains[0]}" >> /etc/resolv.conf
for i in "${search_domains[@]:1}"
do
echo "search $i" >> /etc/resolv.conf
done

# Setup hosts file
echo "127.0.0.1   ${hostname}" >> /etc/hosts


echo "127.0.0.1   


systemctl restart NetworkManager

# Set up SSH authorized hosts
mkdir ~/.ssh
touch ~/.authorized_keys
echo "Enter SSH authorized hosts separated by a space:"
read -a ssh_hosts
for i in "${ssh_hosts[@]}"
do
echo "Adding $i to SSH authorized hosts"
echo "$i" >> ~/.ssh/authorized_keys
done

sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && sudo cat /etc/ssh/sshd_config
systemctl restart sshd && sudo systemctl status sshd


# Update package manager
dnf makecache --refresh
dnf update -y

# Install core utils
dnf install epel-release -y
dnf install epel-next-release -y
dnf install vim -y
dnf install htop -y
dnf install tar -y
dnf install git -y
dnf install wget -y
dnf install net-tools -y
dnf install telnet -y
dnf install nc -y
dnf install open-vm-tools -y

# Set selinux to off/permissive
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config && cat /etc/selinux/config

# Add package installs
echo "Enter any necessary package installs separated by a space:"
read -a packages
dnf install -y ${packages[@]}

echo "Your box has been strapped."
echo "You can access it now at ${ip_address} or ${hostname} via ssh."