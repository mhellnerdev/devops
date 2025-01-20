#!/bin/bash

# Detect Linux distribution
source /etc/os-release

echo "Detected distribution: $ID"

# Common configuration: Set hostname
echo "Enter hostname:"
read hostname
hostnamectl set-hostname $hostname

# Set up networking
echo "Enter IP address (e.g., 192.168.1.10/24):"
read ip_address
echo "Enter gateway:"
read gateway
echo "Enter network interface (e.g., eth0):"
ip link show | awk -F: '{print $2}'
read interface
echo "Enter DNS Servers separated by a space:"
read -a dns_servers

if [[ "$ID" == "ubuntu" ]]; then
    echo "Setting up networking for Ubuntu"
    # Ensure the file exists and has proper permissions
    netplan_config="/etc/netplan/01-netcfg.yaml"
    sudo touch $netplan_config
    sudo chmod 600 $netplan_config

    # Ubuntu network configuration using netplan
    cat <<EOF | sudo tee $netplan_config
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      addresses:
        - $ip_address
      routes:
        - to: default
          via: $gateway
      nameservers:
        addresses: [${dns_servers[@]}]
EOF
    sudo netplan apply
elif [[ "$ID" =~ (rhel|centos|fedora) ]]; then
    echo "Setting up networking for RHEL-based distro"
    nmcli connection add type ethernet con-name ${interface}-connection ifname $interface
    nmcli connection modify ${interface}-connection ipv4.method manual ipv4.addresses $ip_address ipv4.gateway $gateway ipv4.dns "${dns_servers[*]}"
    nmcli connection up ${interface}-connection
else
    echo "Unsupported distribution: $ID"
    exit 1
fi

# Setup hosts file
cat <<EOF | sudo tee /etc/hosts
127.0.0.1   $hostname
EOF

# Set up SSH authorized hosts for root
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh
sudo touch /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# Add root public key
cat <<EOF | sudo tee /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiEsXxd4nzkfzuJiyH5JU7HKpZF+F6TcDcaicM7iMKDqKSCJRSzjAwKtldhXwuCIp/By6s9ReZOC+NdCWJOxfeV8sZTztbbNAvYt1XtcW++EPqzP6LqicKNX58yvlHYj6WNXoOYyMbrQBMLl5DAbbZb0vpN1t2hQVEI9Xp/SD1KBXddC1NicXMwrSgCrJa+ad2gvpqN9dqDHLbYcmXkkpkxpHVwVdVLoaiSpKLqJVE3b+aKX3BbA8HaIxyk+WfYBRdorcD7hRrFtuCcXhRPuSsnp0bnjRxE64IuIDkgGQs3N71s7tjzWyg/ktxkCcSp6bsXuJBz5GpLlD7ATPHqkwM0Nketru0r/xZDi5OlnwylsXcoUUlZQblgRY90tQXGo/mth0WR4jIHhNekjNxNtuMhRyvacquKrVe9rZdZcur4cj/woe0w1lCQyBamr/yr3nBbJqL5Yyr23zM4gxNaQ7/50iLX0kJQKVyCI6Ce8o0DPv4g+wUhZifqWBr2JtKKr8= nutanix-env-root-key
EOF

# Ensure circlelabs user exists and set up SSH for it
if ! id -u circlelabs >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash circlelabs
fi

sudo mkdir -p /home/circlelabs/.ssh
sudo chmod 700 /home/circlelabs/.ssh
sudo touch /home/circlelabs/.ssh/authorized_keys
sudo chmod 600 /home/circlelabs/.ssh/authorized_keys

# Add the same key for circlelabs user
cat <<EOF | sudo tee /home/circlelabs/.ssh/authorized_keys
ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
EOF

sudo chown -R circlelabs:circlelabs /home/circlelabs/.ssh

# Ensure circlelabs is in sudoers file without password prompt
echo "circlelabs ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/circlelabs
sudo chmod 440 /etc/sudoers.d/circlelabs

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl restart ssh || sudo systemctl restart sshd

# Update package manager
if [[ "$ID" == "ubuntu" ]]; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y vim htop tar git wget net-tools telnet
    sudo ufw disable
elif [[ "$ID" =~ (rhel|centos|fedora) ]]; then
    sudo dnf makecache --refresh
    sudo dnf update -y
    sudo dnf install -y vim htop tar git wget net-tools telnet
    sudo systemctl disable firewalld --now
fi

# Add additional package installs
echo "Enter any necessary package installs separated by a space:"
read -a packages
if [[ "$ID" == "ubuntu" ]]; then
    sudo apt install -y "${packages[@]}"
elif [[ "$ID" =~ (rhel|centos|fedora) ]]; then
    sudo dnf install -y "${packages[@]}"
fi

echo "Your box has been strapped."
echo "You can access it now at $ip_address or $hostname via ssh."
