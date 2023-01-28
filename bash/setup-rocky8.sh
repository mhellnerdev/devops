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
nmcli connection modify ${interface}-connection ipv4.method manual ipv4.addresses ${ip_address}/${netmask} ipv4.gateway ${gateway} ipv4.dns "${dns_servers}"
nmcli connection up ens192-connection

# Set DNS servers
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
cat <<EOF | tee /etc/hosts
127.0.0.1   ${hostname}
EOF

systemctl restart NetworkManager

# Set up SSH authorized hosts
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add root public key
cat <<EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDA0gVfgR4oK8XdRR2mRPEnS61V2uv63KRyEOR4ar7bzhMO30o7WfR9Q8nWtVHvKQ2SnNzQUP/986YfwTVWus9SZ6xSokzAeDv6+jciI5/+5Xr5G49TtKxWYqJRqv8fB/ceOX6Gn7X0v6ac4zQDQOsFD3iFUJISA6JSO+gqo8IWNDDyOJzj9SkZMSZFSoYnuCRgytCVh4CBUjwtcl5GQoCeles8YI+XLGy4j6njypFGfUtRoceNeMo5rYEt0rXFKtvD1QvCisFKATelOVRxJWsnNHg1G7v6spZnGJP6FiY0111EWPptbFMgPjH4YFNhGe9qHsbJdYoaWMhj6yxNUTmldY2osZYusk2fMOuqyln37gcnMkCIaNwb6EFx1bBHHT2h6YD64OFH/bJc+Tdnq9xKy2SAopArOJefr87xP3yVOZZXSpuxgxsLa5wwc8qqEXuQKo/DF7wZL3kIOnL1I41NpJMmVEgz4QhiCO0U8VZqUV17dWrQdQ8IPUFEqP3Rtc1NiM03XXnUkCQN8+KGMd6LHMSkRJG8cnHZqywbK88M60ocsNuPmncEsJSn9B7o8rmDkMdviwyPzR3DBKD6KhpOMhJVnDAIPTefK4m+Lk6AADtlc60h406sOlMyMT4xjqfogKWyuLwUFlp6Ctk4URG0QuFgXogx4PkXRcKl0O+aGw== awx-key
EOF

sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd

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
echo "Setting SELINUX to permissive"
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config

# Add package installs
echo "Enter any necessary package installs separated by a space:"
read -a packages
dnf install -y ${packages[@]}

echo "Your box has been strapped."
echo "You can access it now at ${ip_address} or ${hostname} via ssh."